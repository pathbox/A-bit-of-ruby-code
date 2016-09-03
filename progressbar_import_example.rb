require 'ruby-progressbar'

IMPORT_LOGGER = Logger.new("#{Rails.root}/log/import.log")
IMPORT_LOGGER.level = Logger::DEBUG

@total = 0
@inc  = 0
@same = 0
@blank = 0

def update_es(company_id, ids)
  Customer.where(company_id: company_id, id: ids).includes(:tags, :other_emails, :cellphones).find_in_batches do |customers|
    Customer.__elasticsearch__.client.bulk({
      index: "customers",
      type: "customer",
      body: customers.map do |customer|
        { index: {_id: customer.id, data: customer.as_indexed_json }}
      end
      })
  end
end

def execute_insert(insert)
  return if insert.blank?
  sql = "INSERT INTO `customers` (`nick_name`, `owner_group_id`, `company_id`, `email`, `created_at`, `updated_at`, `encrypted_password`) VALUES #{insert}"
  ActiveRecord::Base.connection.execute sql
end

def execute_insert_cellphone(insert)
  return if insert.blank?
  sql = "INSERT INTO `contacts` (`customer_id`, `company_id`, `content`, `type`, `created_at`, `updated_at`) VALUES #{insert}"
  ActiveRecord::Base.connection.execute sql
end

def insert_db(conpany_id, file_path, progressbar)
  user_groups = UserGroup.category_common.where(company_id: company_id).pluck(:name, :id).to_h

  ids = []
  failed_indexes = []
  CSV.foreach(file_path, headers: true).with_index(1) do |row, index|
    name = row[0] || '未知客户'
    cellphone = row[1]
    user_group_id = user_groups[[row[2]]]
    if user_group_id.nil? || cellphone.blank?
      IMPORT_LOGGER.error "skip blank data: [#{index}] #{row}"
      @blank += 1
      progressbar.increment
      next
    end

    if ContactCellphone.where(conpany_id: company_id, content: cellphone).exists?
      IMPORT_LOGGER.debug "skip same cellphone: [#{index}] #{row}"
      @same = 1
      progressbar.increment
      next
    end

    email = "#{SecureRandom.hex(8)}@temp.com"
    now = Time.current.to_s(:db)

    begin
      ActiveRecord::Base.transaction do
        # `nick_name`, `owner_group_id`, `company_id`, `email`, `created_at`, `updated_at`, `encrypted_password`
        insert = "(\"#{name}\", #{user_group_id}, #{company_id}, \"#{email}\", \"#{now}\", \"#{now}\", \"$2a$10$l48sLq4qMqIlrrhB1BJ6luO/wHwsb6kZYeTXhyeHAxFfdHol5LgPi\")"
        execute_insert(insert)

        id = Customer.where(company_id: company_id, email: email).pluck(:id).last

        # `customer_id`, `company_id`, `content`, `type`, `created_at`, `updated_at`
        insert = "(#{id}, #{company_id}, \"#{cellphone}\", \"ContactCellphone\", \"#{now}\", \"#{now}\")"
        execute_insert_cellphone(insert)

        ids << id
      end
    rescue => e
      failed_indexes << [idnex, e.message]
    end

    if ids.count == 1000
      update_es(company_id, ids)
      ids = []
    end

    @inc += 1
    progressbar.increment
  end

  update_es(company_id, ids) unless ids.blank?
  return failed_indexes
end

subdomain = 'subdomain'
file_path = $ARGV.last

IMPORT_LOGGER.info "================================================================"
 IMPORT_LOGGER.info "import file: #{file_path} to subdomain"

 rs, err  = nil, nil

 IMPORT_LOGGER.info Benchmark.measure {
    begin
      company_id = Company.where(subdomain: subdomain).pluck(:id).first
      raise "找不到公司: #{subdomain}" if company_id.nil?
      rs = insert_db(company_id, file_path, progressbar)
    rescue => e
      err = e
    end
  }

IMPORT_LOGGER.error "failed line num: #{rs}" unless rs.blank?
IMPORT_LOGGER.error "error: #{err}" unless err.blank?
finish_msg = "[finished] total: #{@total}, inc: #{@inc}, same skip: #{@same}, blank skip: #{@blank}"
IMPORT_LOGGER.info finish_msg
progressbar.log finish_msg
 
