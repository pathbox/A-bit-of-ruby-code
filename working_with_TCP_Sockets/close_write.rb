require 'socket'

server = Socket.new(:INET, :STREAM)
addr = Socket.pack_sockaddr_in(4481, '0.0.0.0')
server.bind(addr)
server.listen(Socket::SOMAXCONN)

connection, _ = server.accept

# After this the connection may no longer write data, but may still read data.
connection.close_write
# After this the connection may no longer read or write any data.
connection.close_read