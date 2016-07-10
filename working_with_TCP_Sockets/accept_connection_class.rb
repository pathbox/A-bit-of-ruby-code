require 'socket'

server = Socket.new(:INET, :STREAM)

addr = Socket.pack_sockaddr_in(4481, '0.0.0.0')
server.bind(addr)
print "Socket max connection in my computer: "
puts Socket::SOMAXCONN
server.listen(Socket::SOMAXCONN)

connection, _ = server.accept

puts connection
puts connection.inspect

print "Connection class: "

p connection.class

print "Server fileno: "
p server.fileno

print "Connection fileno: "
p connection.fileno

print "Local address: "
p connection.local_address

print "Remote address: "
p connection.remote_address

# Yep. At least in the land of Unix everything is treated as a file 3.
# This includes files found on the filesystem as well as things like pipes, sockets, printers, etc.

# The local_address of the connection refers to the endpoint on the local machine. 
# The remote_address of the connection refers to the endpoint at the other end, which might be
# on another host but, in our case, it's on the same machine.
