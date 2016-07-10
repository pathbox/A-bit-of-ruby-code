require 'socket'

server = Socket.new(:INET, :STREAM)
addr = Socket.pack_sockaddr_in(4481, '0.0.0.0')
server.bind(addr)
server.listen(Socket::SOMAXCONN)

# Enter an endless loop of accepting and handling connections.
loop do
	connection, _ = server.accept
	# handle connection
	puts "The connection: "
	puts connection
	connection.close  # 最后会关闭这个connection(socket)。但是由于loop中accept，所以会循环的accept
end