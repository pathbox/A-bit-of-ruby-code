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
