require 'multi_json'
require 'faraday'
require 'elasticsearch/api'

class MySimpleClient
  include Elasticsearch::API

  CONNECTION = ::Faraday::Connection.new url: 'http://localhost:9200'

  def perform_request(method, path, params, body)
    puts "--> #{method.upcase} #{path} #{params} #{body}"

    CONNECTION.run_request \
      method.downcase.to_sym,
      path,
      ( body ? MultiJson.dump(body): nil ),
      {'Content-Type' => 'application/json'}
  end
end

client = MySimpleClient.new

p client.cluster.health
# --> GET _cluster/health {}
# => "{"cluster_name":"elasticsearch" ... }"

p client.index index: 'myindex', type: 'mytype', id: 'custom', body: { title: "Indexing from my client" }
# --> PUT myindex/mytype/custom {} {:title=>"Indexing from my client"}
# => "{"ok":true, ... }"


require 'hashie'

response = client.search index: 'myindex',
                         body: {
                           query: { match: { title: 'test' } },
                           aggregations: { tags: { terms: { field: 'tags' } } }
                         }

mash = Hashie::Mash.new response

mash.hits.hits.first._source.title
# => 'Test'

mash.aggregations.tags.terms.first
# => #<Hashie::Mash count=3 term="z">

Elasticsearch::API.settings[:serializer] = JrJackson::Json
Elasticsearch::API.serializer.dump({foo: 'bar'})
# => {"foo":"bar"}

require 'elasticsearch'

client = Elasticsearch::Client.new url: "localhost:9200", log: true
client.transport.reload_connections!
client.cluster.health
client.search q: 'test'
client.search index: 'articles'
client.index index: 'tests', type: 'test', body: {title: 'foo'}

client.reindex source: {index: 'tests'},
               target: {index: 'tests', client: target_client},
               transdorm: lambda {|doc| doc['_source']['title'].upcase!},
               refresh: true


article_client = Article.__elasticsearch__.client
article_client.count index: 'articles'

Article.__elasticsearch__.client.cluster.health
Article.__elasticsearch__.search 'fox'
Article.__ealsticsearch__.search(query:{}, size: 10, highlight: { fields: { title: {} } })

Elasticsearch::Model.client = Elasticsearch::Client.new log: true

Article.import
Article.import force: true

response = Article.search 'fox dogs'

require 'jbuilder'
query = Jbuilder.encode do |json|
  json.query do
    json.match do
      json.title do
        json.query "fox dogs"
      end
    end
  end
end

response = Article.search query
response.results.first.title
# => "Quick brown fox"

response.took
# => 3

response.results.total
# => 2

response.results.first._score

response.results.to_a
# Article Load (0.3ms)  SELECT "articles".* FROM "articles" WHERE "articles"."id" IN (1, 2)
# => [#<Article id: 1, title: "Quick brown fox">, #<Article id: 2, title: "Fast black dogs">]

response.records.where(title: 'quick brown fox').to_a
# Article Load (0.2ms)  SELECT "articles".* FROM "articles" WHERE "articles"."id" IN (1, 2) AND "articles"."title" = 'Quick brown fox'
# => [#<Article id: 1, title: "Quick brown fox">]

response.records.records.class
# => ActiveRecord::Relation::ActiveRecord_Relation_Article

response.records.order(:title).to_a
# Article Load (0.2ms)  SELECT "articles".* FROM "articles" WHERE "articles"."id" IN (1, 2) ORDER BY "articles".title ASC
# => [#<Article id: 2, title: "Fast black dogs">, #<Article id: 1, title: "Quick brown fox">]

response.results.first._source.title

Elasticsearch::Model.search('fox', [Article, Comment]).results.to_a.map(&:to_hash)
# => [
#      {"_index"=>"articles", "_type"=>"article", "_id"=>"1", "_score"=>0.35136628, "_source"=>...},
#      {"_index"=>"comments", "_type"=>"comment", "_id"=>"1", "_score"=>0.35136628, "_source"=>...}
#    ]

Elasticsearch::Model.search('fox', [Article, Comment]).records.to_a
# Article Load (0.3ms)  SELECT "articles".* FROM "articles" WHERE "articles"."id" IN (1)
# Comment Load (0.2ms)  SELECT "comments".* FROM "comments" WHERE "comments"."id" IN (1,5)
# => [#<Article id: 1, title: "Quick brown fox">, #<Comment id: 1, body: "Fox News">,  ...]

@articles = Article.search(params[:q]).page(params[:page]).records

@articles.current_page
# => 2
@articles.next_page
# => 3

response.results.to_a.map(&:_source)

response.results.map { |r| r._source.title }
# => ["Quick brown fox", "Fast black dogs"]

response.results.select { |r| r.title =~ /^Q/ }
# => [#<Elasticsearch::Model::Response::Result:0x007 ... "_source"=>{"title"=>"Quick brown fox"}}]

response.any? { |r| r.title =~ /fox|dog/ }
# => true






