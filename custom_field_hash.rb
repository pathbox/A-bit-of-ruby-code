class TicketImporter
  MAX_ROW = 1000
  CUSTOM_FIELD_NAME_REGEX = /\A(TextField|SelectField)_\d+\z/i
  SELECT_FIELD_NAME_REGEX = /\ASelectField_\d+\z/i
  TEXT_FIELD_NAME_REGEX   = /\ATextField_\d+\z/i

  def initialize(company, ticket_import_record)
    @company           = company
    @record            = ticket_import_record
    @spreadsheet       = @record.uploaded_spreadsheet
    @sheet             = @spreadsheet.sheet(0)
    @head_data         = @sheet.row(1)
    # @template_name     = @sheet.row(2)[10]
    @last_row          = @sheet.last_row
    @row_count         = @last_row - 1
    @planed_count      = [@row_count, MAX_ROW].min
    @unsuccessful_data = []
    @templates_hash    = template_custom_field_hash
  end

  def start_import
    @record.update!(real_count: @row_count, failure_count: 0, planed_count: @planed_count, treated_count: 0)

    2.upto(@last_row).each do |row_num|
      row = format_cells(row_num)
      if row_num > MAX_ROW + 1
        @unsuccessful_data << [row, "超过1000行"]
      else
        ActiveRecord::Base.transaction do
          begin
          is_valid, value = check_valid(row)
            if is_valid
              attributes = value
              customer_id = validate_email_cellphone(row[2], row[3]).last
              if customer_id.present?
                attributes.merge!({user_id: customer_id})
              else
                group_id = @company.user_groups.category_common.first.try(:id)
                customer = Customer.create!(email: row[2],
                                            company_id: @company.id,
                                            nick_name: "工单导入客户#{Time.now.to_i}",
                                            platform_id: Platform.manual_input.id,
                                            source_channel: 'manual',
                                            owner_group_id: group_id)
                customer.update!(cellphone: row[3]) if customer.id.present? && row[3].present?
                attributes.merge!({user_id: customer.id})
              end
              ticket = Ticket.new(attributes)
              ticket.save!(validate: false)
              @company.tag(row[8], ticket) if row[8].present?
            else
              @unsuccessful_data << [row, value]
            end
          rescue => e
            @unsuccessful_data << [row, "保存失败(#{e.inspect})"]
          end
        end
      end
      @record.update!(failure_count: @unsuccessful_data.size, treated_count: row_num - 1)
    end
    save_unsuccessful_data_to_file
    Sidekiq.logger.info "==================#{@unsuccessful_data}"
    @record.update!(completed: true)
  end

  private

  # 把未导入的数据，写出到一个 csv 文件里，并上传到七牛
  def save_unsuccessful_data_to_file
    if @unsuccessful_data.size > 0
      failure_file_name = 'failure_data_' + Time.now.to_i.to_s + '.csv'
      uploaded_io       = TicketImportRecord.failure_data_csv_content(@head_data, @unsuccessful_data)
      failure_file      = Tempfile.new(failure_file_name, :encoding => 'gb18030')

      begin
        failure_file.write(uploaded_io)
        failure_file.rewind
        put_policy = Qiniu::Auth::PutPolicy.new('udesk')
        code, result, response_headers = Qiniu::Storage.upload_with_put_policy(
          put_policy,        # 上传策略
          failure_file,      # 上传文件
          failure_file_name  # 文件名
        )
        @record.update!(failure_file_name: result['key'])
      ensure
        failure_file.close
        failure_file.unlink  # deletes the temp file
      end
    end
  end

  def format_cells(row_num)
    @sheet.row(row_num).map.with_index do |cell, index|
      case @sheet.celltype(row_num, index + 1)
      when :time
        integer_to_time_str(cell)
      when :datetime
        cell.is_a?(DateTime) ? datetime_to_str(cell) : cell.to_s.try(:strip)
      when :date
        cell.is_a?(Date) ? date_to_str(cell) : cell.to_s.try(:strip)
      when :float
        (cell.is_a?(Float) && cell.to_i == cell) ? cell.to_i : cell.to_s.try(:strip)
      else
        cell.to_s.try(:strip)
      end
    end
  end

  def datetime_to_str(cell)
    cell.strftime("%Y-%m-%d %H:%M:%S")
  end

  def integer_to_time_str(cell)
    Time.at(cell).utc.strftime("%H:%M:%S")
  end

  def date_to_str(cell)
    cell.to_s.try(:strip)
  end

  def check_valid(row)
    params = { company_id: @company.id }
    return [false, '工单标题为空'] if row[0].blank?
    return [false, '状态不存在'] unless ['开启','解决中','已解决','已关闭'].include?(row[4].try(:strip))
    return [false, '优先级不存在'] unless ['紧急','高','标准','低'].include?(row[5].try(:strip))
    agent_id = @company.agents.find_by(email: row[7]).try(:id)

    if row[9].present?
      follower_ary = row[9].split(",").map(&:strip)
      followers = @company.users.avaliable_users.where(email: follower_ary)
      return [false, "关注者邮箱有错误"] if followers.pluck(:email) != follower_ary
    end

    template_id = @company.ticket_templates.find_by(name: row[10]).try(:id)
    return [false, '工单模板为空或不存在'] unless template_id
    # return [false, '数据工单模板不全一样,以第一行数据为准'] unless @template_name == row[10]
    result1 = validate_email_cellphone(row[2], row[3])
    return [false, result1.last] unless result1.first
    result2 = validate_owner_and_owner_group(row[6], row[7])
    return [false, result2.last] unless result2.first
    result3 = validate_custom_fields(row[11..-1], row[10])
    return [false, result3.last] unless result3.first
    status_id = Status.find_by(zh_name: row[4]).try(:id)
    priority_id = Priority.find_by(zh_name: row[5]).try(:id)
    follower_ids = followers.try(:pluck, :id)
    params.merge!({subject: row[0],
                   content: row[1],
                   assignee_id: agent_id,
                   user_group_id: result2.last,
                   custom_fields: result3.last,
                   template_id: template_id,
                   status_id: status_id,
                   priority_id: priority_id,
                   platform_id: Platform.manual_input.id,
                   creator_id: @record.operator_id,
                   follower_ids: follower_ids})
    [true, params]
  end

  def validate_email_cellphone(email, cellphone)
    customer_a_id = nil
    customer_b_id = nil
    if email.present?
      return [false, "邮件格式错误"] unless email =~ EMAIL_REGEXP
      customer_a_id = @company.customers.find_in_emails(email).try(:id)
    end
    if cellphone.present?
      return [false, "电话号码格式错误"] unless PhoneNumber.new(cellphone).valid?
      customer_b_id = @company.customers.find_in_cellphones(cellphone).try(:id)
    end
    if customer_a_id && customer_b_id
      return [false, "邮箱和手机号分属于两个已有客户"] if customer_a_id != customer_b_id
    end
    customer_id = customer_a_id || customer_b_id

    return [true, customer_id]
  end

  def validate_owner_and_owner_group(group_name, owner_email)
    user_group_id = nil
    if owner_email.present?
      unless @company.agents.where(email: owner_email).exists?
        return [false, "受理客服不存在"]
      end
    end
    if group_name.present?
      unless @company.user_groups.where(name: group_name).exists?
        return [false, "受理客服组不存在"]
      end
    end
    if owner_email.present? && group_name.present?
      user_id = @company.agents.find_by(email: owner_email).try(:id)
      user_group_id = @company.user_groups.find_by(name: group_name).try(:id)
      unless UsersUserGroup.where(user_id: user_id, user_group_id: user_group_id).exists?
        return [false, "客户的负责人不属于负责组"]
      end
    end
    return [true, user_group_id]
  end

  def custom_fields_hash(template_name)
    custom_fields = Hashie::Mash.new
    template = @company.ticket_templates.find_by(name: template_name)
    template_fields = template.template_fields.includes(:field)
    template_fields.each do |template_field|
      field = template_field.try(:field)
      if field.present?
        key           = "#{template_field.field_type}_#{template_field.field_id}"
        title         = field.try(:title)
        options       = field.try(:options)
        is_required   = template_field.is_required
        content_type  = field.try(:content_type)
        sort          = template_field.sort
        custom_fields.merge!({ key => { title: title,
                                        is_require: is_required,
                                        content_type: content_type,
                                        options: options
                                      }
                             })
      end
    end
    custom_fields
  end

  def template_custom_field_hash
    templates_hash = Hashie::Mash.new
    @company.ticket_templates.each do |template|
      templates_hash.merge!(template.name => custom_fields_hash(template.name))
    end
    templates_hash
  end

  def validate_custom_fields(columns, template_name)
    field_ary = []
    if columns.present?
      custom_fields = @templates_hash[template_name]
      custom_fields.each_with_index do |custom_field, i|
        key   = custom_field.first
        field = custom_field.last
        column = columns[i]
        return [false, "#{field.title}为必填字段"] if field.is_require && columns[i].blank?
        if field && column.present?
          if field.content_type == "text"
            return [false, "#{column} 单行文本类型字段不能有换行"] if column.to_s.include?("\n")
            field_ary << [key, column.to_s]
          elsif field.content_type == "area_text"
            field_ary << [key, column.to_s]
          elsif field.content_type == "date"
            return [false, "#{column} 日期数据格式不正确"] unless column.to_s.strip =~ TextField::CONTENT_TYPE_PATTERNS[:date]
            field_ary << [key, column]
          elsif field.content_type == "time"
            return [false, "#{column} 时间数据格式不正确"] unless column.to_s.strip =~ TextField::CONTENT_TYPE_PATTERNS[:time]
            field_ary << [key, column]
          elsif field.content_type == "number"
            return [false, "#{column} 不是正整型数据"] if column.to_i < 0 || !(column.to_s =~ TextField::CONTENT_TYPE_PATTERNS[:number])
            field_ary << [key, column]
          elsif field.content_type == "numeric"
            return [false, "#{column} 数值数据格式不正确"] unless column.to_s =~ TextField::CONTENT_TYPE_PATTERNS[:numeric]
            field_ary << [key, column]
          elsif field.content_type == "link"
            return [false, "#{column}超链接格式不正确"] unless column =~ TextField::CONTENT_TYPE_PATTERNS[:link]
            field_ary << [key, column]
          elsif ["droplist","radio"].include?(field.content_type)
            return [false, "#{column} 选项不正确"] unless field.options.include?(column.to_s.strip)
            field_ary << [key, get_index_value(column.to_s.strip, field.options)]
          elsif field.content_type == "checkbox"
            checkbox = column.to_s.split(",")
            return [false, "#{column} 选项不正确"] if (checkbox - field.options).present?
            field_ary << [key, get_index_value(column, field.options)]
          elsif field.content_type == "chained_droplist"
            result = SelectField.get_chained_droplist_value(column.to_s.strip, field.options) #[false, "#{self.title} 字段有错误"]
            return result unless result.first
            field_ary << [key, result.last]
          end
        else
          field_ary << [key, column]
        end
      end
    end
    return [true, field_ary]
  end

  def get_index_value(values, options)
    indexes = []
    ary = values.to_s.split(",")
    ary.each do |value|
      options.each_with_index do |option, index|
        indexes << "#{index}" if option == value
      end
    end
    indexes.join(",")
  end
end
