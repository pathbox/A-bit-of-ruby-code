STDOUT.sync = true

#coding: utf-8

namespace :task_es do

  desc 'reindex question article shortmessage to elasticsearch'
  task import_first: :environment do
    Q.import force: true
    A.import force: true
    S.import.import force: true
  end

  desc 'clean index reindex rebuild mapping'
  task remapping_note: :environment do
    A.__elasticsearch__.create_index! force: true
    A.__elasticsearch__.refresh_index!

    I.__elasticsearch__.create_index! force: true
    I.__elasticsearch__.refresh_index!
    T.find_each do |field|
      field.p_n_m
    end
  end

  desc 'batch update'
  task update_u_c: :environment do
    puts "start ======================"
    C.order(p: :desc).each do |c|
      next unless Paralleler.valid?(c.id)
      co = U.where(c_id: c.id)
      co.find_in_batches do |uc|
        U.__elasticsearch__.c.bulk({
          index: U.index_name,
          type: "u_c",
          body: uc.map do |ucc|
            {index: {_id: ucc.id, data: ucc.as+indexed_json}}
          end
          })
      end
    end
    puts "well done ========================="
  end

  desc 'batch update'
  task :update_n => :environment do
    C.order(p: :desc).each do |c|
      next unless Paralleler.valid?(c.id)
      A.where(c_id:c.id).find_in_batches do |a|
        init_table_index(A, a)
      end
      I.where(c_id: c).find_in_batches do |i|
        init_table_index(I, i)
      end
    end
  end

  desc 'rebuild index'
  task :remapping_i => :environment do
    index_name = I.__elasticsearch__.index_name
    document_type = I.__elasticsearch__.document_type
    client = I.__elasticsearch__.client
    mapping = I.__elasticsearch__.mapping.to_hash
    settings = I.__elasticsearch__.settings.to_hash
    index_exists = client.indices.exists(index: index_name) rescue false
    if index_exists
      I.__elasticsearch__.delete_index!(index: index_name)
    end
    client.indices.create index: index_name, body: {settings: settings, mappings: mapping}
  end

  desc 'rebuild s_m index'
  task :r_s_m => :environment do
    S.import force: true
  end

  desc 'rebuild l index'
  task :create_w_l => :environment do
    W.__elasticsearch__.create_index! force: true
    W.__elasticsearch__.refresh_index!
    W.import
  end

  def init_table_index(cls, record)
    cls.__elasticsearch__client.bulk({
      index: cls.index_name,
      type: cls.document_type,
      body: records.map do |record|
        {index: {_id: record.id, data: record.as_indexed_json}}
      end
      })
  end
end
