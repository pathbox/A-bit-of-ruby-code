STDOUT.sync = true

# 使用rake脚本，根据创建时间参数，和对应表的参数，同步表的数据到ElasticSearch
# rake sync_es:sync_data_es form=2016-03-04 to=2016-09-08 table=Article
# 第一次的时候，要确保有对应的索引存在.table 参数要是对应model的名称
#coding: utf-8

namespace :sync_es do
  desc 'MySQL 数据记录同步到ES'
  task sync_data_es: :environment do
    from  = ENV['form']
    to    = ENV['to']
    model = ENV['table']

    from = Time.parse(from)
    to   = Time.parse(to)
    total = 0
    s = Time.now

    if model.present?
      model = model.camelize.constantize
      error = []
      model.__elasticsearch__.create_index!
      model.where("? < created_at and created_at < ?", from, to).find_in_batches do |records|
        body_ary = []
        records.each do |record|
          begin
            body_ary << { index: { _id: record.id, data: record.as_indexed_json } }
          rescue => e
            options = {}
            options['record_id'] = record.id
            options['occur_at'] = Time.current
            options['exception'] = {}
            options['exception']['message']   = e.try(:message)
            options['exception']['backtrace'] = e.try(:app_backtrace)
            error << options
          end
        end
        model.__elasticsearch__.client.bulk({
                                                index: model.index_name,
                                                type: model.document_type,
                                                body: body_ary
                                            })
        total += 1
        count = total * 1000
        puts "------------------------------ #{count}"
      end
      model.__elasticsearch__.refresh_index!
    else
      puts "class param is invalid or blank"
    end
    e = Time.now
    x = e - s
    puts "Sync work is done~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts "Time Seconds: #{x}"
  end
end