require 'rack/app'

class Racko < Rack::App
	get '/' do
		"Hello World!"
	end
end

run Racko
