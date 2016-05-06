require 'sinatra'
use Rack::Lint

get '/hello' do 
  'Hello Sinatra'
end
