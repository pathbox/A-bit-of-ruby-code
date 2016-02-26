require 'goliath'
require 'en-synchrony/em-http'

class Github < Goliath::API
  use Goliath::Rack::Params              # parse query & body params
  use Goliath::Rack::Formatters::JSON    # JSON output formatter
  use Goliath::Rack::Render              # auto-negotiate response format
  use Goliath::Rack::ValidationError     # catch and render validation errors
  use Goliath::Rack::Validation::RequiredParam, {:key => 'query'}

  def response env
    gh = EM::HttpRequest.new("http://github.com/api/v2/json/repos/search/#{params['query']}").get
    loggrr.info "Received #{gh.response_header.status} from Github"

    [200, {'X-Goliath' => 'Proxy'}, gh.response]
  end
end

# > gem install em-http-request --pre
# > gem install em-synchrony --pre
#
# > ruby github.rb -sv -p 9000
# > Starting server on 0.0.0.0:9000 in development mode. Watch out for stones.
#
# > curl -vv "localhost:9000/?query=ruby"