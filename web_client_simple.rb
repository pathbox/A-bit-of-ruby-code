# gem 'websocket-client-simple'
require 'websocket-client-simple'

ws = WebSocket::Client::Simple.connect 'ws://localhost:8080/echo'

ws.on :message do |msg|
	puts "received data: " + msg.data
end

ws.on :open do
	ws.send 'hello!'
end

ws.on :close do |e|
	p e
	exit 1
end

ws.on :error do |e|
	p e
end

loop do
	ws.send STDIN.gets.strip
end