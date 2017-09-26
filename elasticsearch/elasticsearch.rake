STDOUT.sync = true

#coding: utf-8
client = Elasticsearch::Client.new(
  host: elasticsearch_url,
  retry_on_failure: 0,
  log: true,
  transport_options: { request: { timeout: 10 } }
  )

# 使用方式
# bundle exec rake udesk_es:remapping_index table=Ticket
namespace :udesk_es do

  desc "重建es索引,根据传入的参数指定重置的索引"

  # 索引名称会是 es_name_日期,比如:tickets_2017_09_26
  task remapping_index: :environment do
    date = Time.now.strftime("%Y_%m_%d")
    table = ENV['table']
    puts "++++++ start remapping index #{table}"
    if table.blank?
      puts "model 参数不能为空"
      return
    end

    model = table.camelize.constantize
    index_name = "#{model.index_name}_#{date}"

    if model.__elasticsearch__.index_exists?  # 如果索引存在，先删除，之后再重新新建
      model.__elasticsearch__.delete_index!
    end

    model.__elasticsearch__.create_index! index: index_name, force: true  # ++++++创建索引

    if table == 'ImLog'
      EsOceanClient.indices.put_alias index: index_name, name: model.index_name #创建或更新别名alias，别名就是和MySQL数据库表名一样
    else
      client.indices.put_alias index: index_name, name: model.index_name #创建或更新别名alias，别名就是和MySQL数据库表名一样
    end

    model.__elasticsearch__.refresh_index!  # 最后再refresh_index!， 因为要在别名创建之后才能执行这个命令，要不会找不到索引index_not_found_exception
    puts "+++remapping_index success+++"
  end

end