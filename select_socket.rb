require 'socket'

begin
	socket = Socket.new(:INET, :STREAM)
	socket.bind(Addrinfo.tcp('0.0.0.0', 9091))
	socket.listen(8)
	loop do
		listening, _ = IO.select([socket])
		io,_ = listening
		connection, addrinfo = io.accept
		echo = connection.gets
		connection.puts "="*60
		connection.puts "This is a echo example"
		connection.puts echo
		connection.close
	end
ensure
	socket.close
end
