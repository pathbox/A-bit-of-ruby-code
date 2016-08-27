module EsMapper
  # extend ActiveSupport::Concern
  include MapperCommon
  class << self
    def customer_accessible_by_permission(current_user)
      return nil if current_user.admin?
      permissions = current_user.try(:agent_role).try(:permissions)
      if permissions.blank?
        {term: {owner_id: current_user.id}}
      elsif permissions['customer_show_all']
        nil
      elsif permissions['customer_show_group']
        {or: [
          {terms: {
              owner_group_id: current_user.user_group_ids
          }},
          {term: {
              owner_id: current_user.id
          }}
        ]}
      else
        {term: {owner_id: current_user.id}}
      end
    end

    def customer_switch_anonym(company)
      {term: {is_anonym: false}} if company.switch_anonym
    end

    def customer_prefix_filter(search_key, current_user)
      filter = {}
      if search_key
        company = current_user.company
        prefix_key = search_key
        filter[:bool] = {
          must: [{term: {company_id: company.id}}],
          should: [
            {prefix: {"nick_name.raw" => "#{prefix_key}"}},
            {prefix: {"cellphone.raw" => "#{prefix_key}"}},
            {prefix: {"emails.raw"    => "#{prefix_key}"}}
          ]
        }
      end
      return filter
    end

    def customer_sort(sort_by, company)
      sorts = ["_score"]
      sort_by.to_a.uniq.each do |sort|
        case sort[0]
        when 'nick_name'
          sorts << {'nick_name.raw' => (sort[1] || "asc")}
        when 'created_at', 'updated_at'
          sorts << {sort[0] => (sort[1] || "asc")}
        when /^TextField_[0-9]+$/, /^SelectField_[0-9]+$/
          sorting = sort_by_custom_field(sort[0], sort[1], company, CustomFieldOwnerCustomer)
          sorts << sorting if sorting
        else
          raise "不能识别排序#{sort[0]}"
        end
      end
      sorts << {id: :desc}
      return sorts
    end

    def customer_query(all_conditions, search_key, current_user)
      filter = customer_query_by_filter(all_conditions, current_user)
      search = customer_query_by_search(search_key, current_user.company)
      query = {filtered: {}}
      query[:filtered][:filter] = filter unless filter.blank?
      query[:filtered][:query] = search unless search.blank?

      return query
    end

    def  customer_query_by_filter(all_conditions, current_user)
      company = current_user.company
      filters = {must: [], must_not: []}

      permission_scope = customer_accessible_by_permission(current_user)
      filters[:must] << permission_scope unless permission_scope.nil?
      anonym_scope = customer_switch_anonym(current_user.company)
      filters[:must] << anonym_scope unless anonym_scope.nil?

      all_conditions.to_a.uniq.each do |clause|
        condition = clause.clone.deep_symbolize_keys
        if ["SelectField", "TextField"].include?(condition[:field_name].to_s.split("_")[0])
          custom_field_filter condition, filters, current_user, current_user.company, CustomFieldOwnerCustomer
          next
        end
        customer_field_filter(condition, filters, current_user)
      end
      query = {bool: filters}
      return query
    end

    def customer_field_filter(condition, filters, current_user)
      case condition[:field_name]
      when 'owner_id'
        options_filter condition, filters, current_user, "customer_owner", "owner_id"
      when 'nick_name'
        base_convert filters, 'nick_name.raw', condition[:operation], [condition[:value]], 'string'
      when 'organization'
        base_convert filters, 'organization.raw', condition[:operation], [condition[:value]], 'string'
      when 'emails'
      base_convert filters, 'emails.raw', condition[:operation], [condition[:value]], 'string'
      when 'cellphone'
        base_convert filters, 'cellphone.raw', condition[:operation], [condition[:value]], 'string'
      when 'tags'
        base_convert filters, 'tags.id', condition[:operation], condition[:value].try(:split, ',').try(:select, &:present?), 'array'
      when 'created_at'
        datetime_filter condition, filters, "created_at"
      when 'updated_at'
        datetime_filter condition, filters, "updated_at"
      when 'owner_group_id'
        options_filter condition, filters, current_user, "customer_owner_group", "owner_group_id"
      when 'description'
        base_convert filters, 'description.raw', condition[:operation], [condition[:value]], 'string'
      when 'source_channel'
        options_str_filter condition, filters, "source_channel"
      when "province", "city", "phone_service_provider", "isp"
        base_convert filters, "#{condition[:field_name]}.raw", condition[:operation], [condition[:value]], 'string'
      when "os", "os_version", "browser", "phone_modal", "resolution"
        base_convert filters, "latest_device_info.#{condition[:field_name]}.raw", condition[:operation], [condition[:value]], 'string'
      when "last_contact_at", "first_contact_at", "last_contact_at_via_phone", "first_contact_at_via_phone", "last_contact_at_via_im", "first_contact_at_via_im"
        datetime_filter condition, filters, condition[:field_name]
      when "contact_count", "contact_count_via_phone", "contact_count_via_im"
        number_filter condition, filters, "integer", condition[:field_name]
      when 'is_blocked'
        boolean_filter condition, filters
      else
        raise "不能识别的字段#{condition[:field_name]}"
      end
    end

    def customer_query_by_search(search_key, company)
      return {} if search_key.blank?
      phrase_field_names =  ['nick_name.tokenized', 'emails.tokenized', 'cellphone.tokenized', 'organization.tokenized']
      field_name = ['tags.name']

      types = [
        TextField::ContentType[:text],
        TextField::ContentType[:area_text],
        TextField::ContentType[:link]
      ]

      text_fields = company.text_fields.belong_customer.where(content_type: types)
      text_fields.each do |fields|
        if field.content_type == TextField::ContentType[:link]
          field_names << field.custom_field_name
        else
          phrase_field_names << "#{field.custom_field_name}.tokenized"
        end
      end

      query = {
        bool: {
          should: [
            {
            multi_match: {
              query: search_key,
              fields: field_names
            }
          },
          {
            multi_match: {
              query: search_key,
              type: 'phrase',
              slop: 0,
              fields: phrase_field_names,
              analyzer: 'char_split',
              max_expansions: 1
            }
          }
         ]
        }
      }

      return query
    end

    def ticket_sort(sort_by, company)
      sirts = ["_score"]
      sort_by.to_a.uniq.each do |sort|
        case sort[0]
        when "subject"
          sorts << {"subject.raw" => (sort[1] || "asc")}
        when "priority"
          sorts << {priority_id: (sort[1] || "asc")}
        when "status"
          sorts << {status_id: (sort[1] || "asc")}
        when "created_at"
          sorts << {created_at: (sort[1] || "asc")}
        when "updated_at"
          sorts << {updated_at: (sort[1] || "asc")}
        when "last_replied_at"
          sorts << {replied_at: (sort[1] || "asc")}
        when "last_agent_replied_at"
          sorts << {agent_replied_at: (sort[1] || "asc")}
        when "last_customer_replied_at"
          sorts << {customer_replied_at: (sort[1] || "asc")}
        when "agent_group_id"
          sorts << {user_group_id: (sort[1] || "asc")}
        when "assignee_id"
          sorts << {assignee_id: (sort[1] || "asc")}
        when "customer_id"
          sorts << {user_id: (sort[1] || "asc")}
        when "platform"
          sorts << {platform_id: (sort[1] || "asc")}
        when "solved_deadline"
          sorts << {solved_deadline: (sort[1] || "asc")}
        when 'field_num'
          sorts << {id: (sort[1] || "asc")}
          sorts << {field_num: (sort[1] || "asc")}
        when 'template_id'
          sorts << {template_id: (sort[1] || "asc")}
        when /^TextField_[0-9]+$/, /^SelectField_[0-9]+$/
          sorting = sort_by_custom_field(sort[0], sort[1], company, CustomFieldOwnerTicket)
          sorts << sorting if sorting
        else
          raise "不能识别的排序字段 #{sort[0] }"
        end
      end
      sorts << {id: :desc}
      sorts
    end

    def ticket_query_by_search(search_key, company)
      return {} if search_key.blank?
      phrase_field_names = ['subject.tokenized']
      field_names = ['parse_content', 'replies.content_string', 'tags.name']

      types = [
        TextField::ContentType[:text],
        TextField::ContentType[:area_text],
        TextField::ContentType[:link]
      ]

      text_fields = company.text_fields.belong_ticket.where(content_type: types)
      text_fields.each do |field|
        if field.content_type == TextField::ContentType[:link]
          field_names << field.custom_field_name
        else
          phrase_field_names << "#{field.custom_field_name}.tokenized"
        end
      end

      query = {
        bool: {
          should: [
            {
              multi_match: {
                query: search_key,
                fields: field_names
              }
            },
            {
              multi_match: {
                query: search_key,
                type: 'phrase',
                slop: 0,
                fields: phrase_field_names,
                analyzer: 'char_split',
                max_expansions: 1
              }
            }
          ]
        }
      }

      return query
    end

    def ticket_query_by_filter(all_conditions, current_user, company)
      filters = {must: [], must_not: []}
      if current_user.try(:agent?)
        case current_user.ticket_permission
        when 1
          user_group_ids = current_user.user_group.category_common.pluck(:id)
          filters[:must] << {
            or: [
              {terms: { user_group_id: user_group_ids}},
              {term: {assignee_id: current_user.id}},
              {term: {'followers.id' => current_user.id}
            ]
          }
        when 2
          filters[:must] << {
            or: [
              {term: {assignee_id: current_user.id}},
              {term: {'followers.id' => current_user.id}}
            ]
          }
        end
      elsif current_user.try(:customer?)
        filters[:must] << {term: {user_id: current_user.id}}
      end
      filters[:must] << {term: {company_id: company.id}}

      all_conditions.to_a.uniq.each do |clause|
        condition = clause.clone.deep_symbolize_keys
        if ["SelectField", "TextField"].include?(condition[:field_name].to_s.split("_")[0])
          custom_field_filter(condition, filters, current_user, company, CustomFieldOwnerTicket)
          next
        end
        ticket_field_filter(condition, filters, current_user)
      end
      query = {bool: filters}
      return query
    end

    def ticket_field_filter(condition, filters, current_user)
      case condition[:field_name]
      when 'customer_id'
        options_filter condition, filters, current_user, "integer", "uer_id"
      when 'assignee_id'
        options_filter condition, filters, current_user, "ticket_assignee", "assignee_id"
      when 'followers'
        options_filter condition, filters, current_user, "ticket_followers", "followers.id"
      when 'agent_group_id'
        options_filter condition, filters, current_user, "ticket_agent_group", "user_group_id"
      when 'status'
        options_filter condition, filters, current_user, "ticket_status", "status_id"
      when 'platform'
        options_filter condition, filters, current_user, "ticket_platform", "platform_id"
      when 'priority'
        options_filter condition, filters, current_user, "ticket_priority", "priority_id"
      when 'created_at'
        datetime_filter condition, filters, "created_at"
      when 'last_replied_at'
        datetime_filter condition, filters, "replied_at"
      when 'last_agent_replied_at'
        datetime_filter condition, filters, "agent_replied_at"
      when 'last_customer_replied_at'
        datetime_filter condition, filters, "customer_replied_at"
      when 'after_updated_hours', 'after_created_hours', 'after_solving_hours', 'after_resolved_hours',
           'after_closed_hours', 'after_assigned_hours', 'after_assignee_updated_hours', 'after_creator_updated_hours',
           'after_solved_deadline_hours'
        current_date = Time.zone.now
        case condition[:operation]
        when 'gte'
          condition[:operation] = 'lte'
          condition[;value] = (current_date - condition[:value].to_i.hours).to_s
        when 'lte'
          condition[:operation] = 'gte'
          condition[:value] (current_date - condition[:value].to_i.hours).to_s
        when 'is'
          condition[:operation] = "range"
          value = (current_date - condition[:value].to_i.hours)
          condition[:value] = []
          condition[:value] << value.beginning_of_hour.to_s
          condition[:value] << value.end_of_hour.to_s
        end
        case condition[:field_name]
        when 'after_soliving_hours'
          base_convert filters, 'status_id', 'is', [Status.solving.id], ""
        when 'after_resolved_hours'
          base_convert filters, 'status_id', 'is', [Status.resolved.id], ""
        when 'after_closed_hours'
          base_convert filters, 'status_id', 'is', [Status.closed.id], ""
        end
        datetime_filter condition, filters, EsMapper::TICKET_HOUR_CONDITION_FIELD_NAMES[condition[:field_name]]
      when 'before_solved_deadline_hours'
        current_date = Time.zone.now
        case condition[:operation]
        when 'is'
         condition[:operation] = "range"
         value = (current_date + condition[:value].to_i.hours)
         condition[:value] = []
         condition[:value] << value.beginning_of_hour.to_s
         condition[:value] << value.end_of_hour.to_s
         when 'lte'
           condition[:operation] = "range"
           value = (current_date + condition[:value].to_i.hours).to_s
           condition[:value] = []
           condition[:value] << current_date.to_s
           condition[:value] << value.to_s
         when 'gte'
           condition[:value] = (current_date + condition[:value].to_i.hours).to_s
         end
         datetime_filter condition, filters, "solved_deadline"
      when 'last_replier_type'
        last_replier_type_filter condition, filters, current_user
      when 'tags'
        base_convert filters, 'tags.id', condition[:operation], condition[:value].try(:split, ',').try(:select, &:present?), 'array'
      when 'organization'
        base_convert filters, 'organization.id', condition[:operation], condition[:value].try(:split, ',').try(:select, &:present?), 'array'
      when 'subject'
        base_convert filters, 'subject.raw', condition[:operation], [condition[:value]], 'string'
      when 'forward_email'
        base_convert filters, 'forward_email', condition[:operation], [condition[:value]], 'string'
      when 'solved_deadline'
        current_date = Time.zone.now
        case condition[:operation]
        when "gte"
          condition[:value] = (current_date + condition[:value].to_i.seconds).to_s
        when "lte"
          condition[:operation] = "range"
          end_date = current_date + condition[:value].to_i.seconds
          condition[:value] = "#{current_date},#{end_date}"
        when "expired" # 逾期
          condition[:operation] = "lte"
          condition[:value] = current_date.to_s
        end

        datetime_filter condition, filters, 'solved_deadline'
      when 'field_num'
        base_convert filters, 'field_num', condition[:operation], [condition[:value]], 'string'
      when 'creator_id'
        options_filter condition, filters, current_user, "ticket_creator", "creator_id"
      when 'template_id'
        options_filter condition, filters, current_user, 'template_id'
      else
        raise "不能识别的字段#{condition[:field_name]}"
      end
    end

    def note_sort(sort_by, company)
      sorts = ["_score"]
      sort_by.to_a.uniq.each do |sort|
        case sort[0]
        when 'company_id', 'customer_id', 'agent_id', 'created_at'
          sorts << {sort[0] => (sort[1] || "asc")}
        when 'type'
          sorts << {session_type: (sort[1] || "asc")}
        when /^TextField_[0-9]+$/, /^SelectField_[0-9]+$/
          sorting = sort_by_custom_field(sort[0], sort[1], company, CustomFieldOwnerTicket)
          sorts << sorting if sorting
        else
          raise "不能识别的排序字段 #{sort[0] }"
        end
      end
      sorts << {id: :desc}
      sorts
    end

    def note_query(params, user, company)
      filter = note_query_by_filter(params[:all_conditions], user)
      assign_content(filter, params[:content], ["content"]) if params[:content].present?
      query = {filtered: {}}
      query[:filtered][:filter] = filter unless filter.blank?
      return query
    end

    def note_query_by_filter(all_conditions, current_user)
      filters = {must: [], must_not: []}
      filters[:must] << {term: {company_id: current_user.company_id}}
      all_conditions.to_a.uniq.each do |clause|
        condition = clause.clone.deep_symbolize_keys
        if ["SelectField", "TextField"].include?(condition[:field_name].to_s.split("_")[0])
          custom_field_filter condition, filters, current_user, current_user.company, CustomFieldOwnerTicket
          next
        end
        note_field_filter(condition, filters, current_user)
      end
      query = {bool: filters}
      return query
    end

    def note_field_filter(condition, filters, current_user)
      case condition[:field_name]
      when 'customer_ids', 'agent_ids'
        options_filter condition, filterts, current_user, 'integer', condition[:field_name].singularize
      when 'session_types'
        if condition[:value].inlcude?("call")
          case current_user.company.callcenter_status
          when CallcenterOpenUcapp
            condition[:value] = condition[:value].gsub("call", "ucp_call")
          when CallcenterOpenHuwapp
            condition[:value] = condition[:value].gsub("call", "huw_call")
          end
        end
        options_filter condition, filters, current_user, condition[:field_name].singularize, condition[:field_name].singularize
      when 'created_at'
      datetime_filter condition, filters, "created_at"
      else
        raise "不能识别的字段#{condition[:field_name]}"
      end
    end

    def im_sort(sort_by, company)
      sorts = ["_score"]
      sort_by.to_a.uniq.each do |sort|
        case sort[0]
        when 'company_id', 'customer_id', 'agent_id', 'created_at'
          sorts << {sort[0] => (sort[1] || "asc")}
        when /^TextField_[0-9]+$/, /^SelectField_[0-9]+$/
          sorting = sort_by_custom_field(sort[0], sort[1], company, CustomFieldOwnerTicket)
          sorts << sorting if sorting
        else
          raise "不能识别的排序字段 #{sort[0] }"
        end
      end
      sorts << {id: :desc}
      sorts
    end

    def im_query(params, user, company)
      filter = im_query_by_filter(params[:all_conditions], user)
      assign_content(filter, params[:content], ["im_logs.content_to_search.tokenized", "agent_note.content.tokenized"]) if params[:content].present?
      query = {filtered: {}}
      query[:filtered][:filter] = filter unless filter.blank?
      return query
    end


    def im_query_by_filter(all_conditions, current_user)
      filters = {must: [], must_not: []}
      filters[:must] << {term: {company_id: current_user.company_id}}
      all_conditions.to_a.uniq.each do |clause|
        condition = clause.clone.deep_symbolize_keys
        if ["SelectField", "TextField"].include?(condition[:field_name].to_s.split("_")[0])
          custom_field_filter condition, filters, current_user, current_user.company, CustomFieldOwnerTicket
          next
        end

        im_field_filter(condition, filters, current_user)
      end

      query = {bool: filters}
      return query
    end

    def im_field_filter(condition, filters, current_user)
      case condition[:field_name]
      when 'customer_ids', 'agent_ids', 'survey_option_ids'
        options_filter condition, filters, current_user, "integer", condition[:field_name].singularize
      when 'src', 'src_url', 'keyword', 'generated_channel', 'login_url', 'session_url', 'ip', 'ip_loc', 'customer_msg_num', 'agent_msg_num', 'resp_seconds', 'sustain_seconds', 'district_id'
        options_filter condition, filters, current_user, condition[:field_name]
      when 'platforms'
        options_filter condition, filters, current_user, "platform", condition[:field_name].singularize
      when 'created_at'
        datetime_filter condition, filters, "created_at"
      else
        raise "不能识别的字段#{condition[:field_name]}"
      end
    end

    # im related end

    def last_replier_type_filter(condition, filters, current_user)
      if condition[:value] == "current_user"
        return if current_user.nil?
        base_convert(filters, "replier_type", "is", ["agent"], "")
        condition[:value] = current_user.id
        field_name = "replier_id"
      else
        field_name = "replier_type"
      end
      base_convert filters, field_name, "is", [condition[:value]], ""
    end
  end
end
