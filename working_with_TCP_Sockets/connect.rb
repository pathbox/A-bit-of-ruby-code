require 'socket'

socket = Socket.new(:INET, :STREAM)

remote_addr = Socket.pack_sockaddr_in(80, 'hao123.com')

socket.connect(remote_addr)

# Again, since we're using the low-level primitives here we're needing to pack the address object into its C struct representation.