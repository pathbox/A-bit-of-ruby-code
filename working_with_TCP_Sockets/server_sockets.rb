require 'socket'

servers = Socket.tcp_server_sockets(4481)

# Creating a TCPServer instance actually returns an instance of TCPServer , not Socket . The interface exposed 
# by each of them is nearly identical, but with some key differences. The most notable of which is that 
# TCPServer#accept returns only the connection, not the remote_address .
# Notice that we didn't specify the size of the listen queue for these constructors? Rather than using 
# Socket::SOMAXCONN , Ruby defaults to a listen queue of size 5 . If you need a bigger listen queue you can 
# call TCPServer#listen after the fact.