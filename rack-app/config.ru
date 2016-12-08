require 'json'
require 'rack/app'

class MyApp < Rack::App
  headers 'Access-Control-Allow-Origin' => '*',
          'Access-Control-Expose-Headers' => 'X-My-Custom-Header, X-Another-Custom-Header'

  serializer do |obj|
    if obj.is_a?(String)
      obj
    else
      JSON.dump(obj)
    end
  end

  error StandardError, NoMethodError do |ex|
    { error: ex.message }
  end

  get '/bad/endpoint' do
    no_method_error_here
  end

  desc 'hello word endpoint'
  validate_params do
    required 'words', class: Array, of: String,
                      desc: 'words that will be joined with space',
                      example: %w(dog cat)
    required 'to', class: String,
                   desc: 'the subject of the conversation'
  end
  get '/validated' do 
    return "Hello #{validate_params['to']}: #{validate_params['words'].join(' ')}"
  end

  get '/' do
    { hello: 'word'}
  end

  mount MediaFileServer, to: "/assets"
  mount Uploader, to: '/upload'
end

run MyApp

