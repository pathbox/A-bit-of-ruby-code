class Article
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name  "articles" 
  document_type "article"
  settings index: { number_of_shards: 5} do
    mappings dynamic: 'false' do
      indexes :title, analyzer: 'english', index_options: 'offsets'
    end
  end
end

Article.mappings.to_hash

Article.settings.to_hash

Article.__elasticsearch__.client.indices.delete index: Article.index_name rescue nil

Article.__elasticsearch__.client.indices.create \
  index: Article.index_name,
  body: { settings: Article.settings.to_hash, mappings: Article.mappings.to_hash}

Article.__elasticsearch__.create_index! force: true #重建索引会将索引清空，然后根据mapping重建索引结构，没有导入数据

Article.__elasticsearch__.refresh_index!

Article.import # 导入数据,根据id，如果数据存在，则为update操作，不存在，则为create操作

Article.import force: true # above three steps

class Article
  include Elasticsearch::Model

  after_save   { logger.debug ["Updating document...", index_document ].join }
  after_destroy { logger.debug ["Deleting document... ", delete_document ].join}
end

class Article < ActiveRecord::Base
  include Elasticsearch::Model

  after_commit on: [:create] do
    __elasticsearch__.index_document if self.published?
  end

  after_commit on: [:update] do
    __elasticsearch__.update_document if self.published?
  end

  after_commit on: [:destroy] do
    __elasticsearch__.delete_document if self.published?
  end
end

class Article
  include Elasticsearch::Model

  after_save {Indexer.perform_async(:index, self.id)}
end

class Indexer
  include Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch', retry: false

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  Client = Elasticsearch::Client.new host: 'localhost:9200', logger: Logger

  def perform(operation, record_id)
    logger.debug [operation, "ID: #{record_id}"]

    case operation.to_s
      when /index/
        record = Article.find(record_id)
        Client.index  index: 'articles', type: 'article', id: record.id, body: record.as_indexed_json
      when /delete/
        Client.delete index: 'articles', type: 'article', id: record_id
      else raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end

Elasticsearch::Model::Serializing

Article.first.__elasticsearch__.as_indexed_json
# => {"id"=>1, "title"=>"Quick brown fox"}

class Article
  include Elasticsearch::Model

  def as_indexed_json(options={})
    as_json(only: 'title')
  end
end

Article.first.as_indexed_json
# => {"title"=>"Quick brown fox"}

def as_indexed_json(options={})
  self.as_json(
    include: { categories: { only: :title},
               authors:    { methods: [:full_name], only: [:full_name] },
               comments:   { only: :text }
             })
end

Article.first.as_indexed_json
# => { "id"         => 1,
#      "title"      => "First Article",
#      "created_at" => 2013-12-03 13:39:02 UTC,
#      "updated_at" => 2013-12-03 13:39:02 UTC,
#      "categories" => [ { "title" => "One" } ],
#      "authors"    => [ { "full_name" => "John Smith" } ],
#      "comments"   => [ { "text" => "First comment" } ] }


