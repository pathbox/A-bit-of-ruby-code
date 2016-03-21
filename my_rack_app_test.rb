require 'rack'

app = Proc.new do |env|
  ['200', {"Content-Type" => "text/html"}, ['A example rack app']]
end

Rack::Handler::WERrick.run app