class Aticle
  include Elasticsearch::Model
  after_save { Indexer.perform_async(:index, self.id)}
  after_destroy { Indexer.perform_async(:delete, self.id)}
end

cladd Indexer
  include Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch', retry: false

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  Client = Elasticsearch::Client.new host: 'localhost:9200', logger: Logger

  def perform(operation, record_id)
    logger.debug [operation, "ID: #{record_id}"]

    case operation.to_s
    when /index/
      record = Article.find(record_id)
      Client.index index: 'articles', type: 'article', id: record.id, body: record.as_indexed_json
    when /delete/
      Client.delete index: 'articles', type: 'article', id: record.id
    else raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end

# Start the Sidekiq workers with bundle exec sidekiq --queue elasticsearch --verbose and update a model:?
# Article.first.update_attribute :title, 'Updated'
# You'll see the job being processed in the console where you started the Sidekiq worker:
#
# Indexer JID-eb7e2daf389a1e5e83697128 DEBUG: ["index", "ID: 7"]
# Indexer JID-eb7e2daf389a1e5e83697128 INFO: PUT http://localhost:9200/articles/article/1 [status:200, request:0.004s, query:n/a]
# Indexer JID-eb7e2daf389a1e5e83697128 DEBUG: > {"id":1,"title":"Updated", ...}
# Indexer JID-eb7e2daf389a1e5e83697128 DEBUG: < {"ok":true,"_index":"articles","_type":"article","_id":"1","_version":6}
# Indexer JID-eb7e2daf389a1e5e83697128 INFO: done: 0.006 sec
