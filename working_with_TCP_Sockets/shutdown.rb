# close will close the socket instance on which it's called. If there are other copies of the socket in 
# the system then those will not be closed and the underlying resources will not be reclaimed. Indeed, 
# other copies of the connection may still exchange data even if one instance is closed.

# So shutdown , unlike close , will fully shut down communication on the current socket and other copies of it, 
# thereby disabling any communication happening on the current instance as well as any copies. But it does not reclaim 
# resources used by the socket. Each individual socket instance must still be close d to complete the lifecycle

require 'socket'
# ./code/snippets/shutdown.rb
# Create the server socket.
server = Socket.new(:INET, :STREAM)
addr = Socket.pack_sockaddr_in(4481, '0.0.0.0')
server.bind(addr)
server.listen(Socket::SOMAXCONN)
connection, _ = server.accept
# Create a copy of the connection.
copy = connection.dup
# This shuts down communication on all copies of the connection.
connection.shutdown

# This closes the original connection. The copy will be closed
# when the GC collects it.
connection.close