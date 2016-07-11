require 'socket'

socket = Socket.new(:INET, :STREAM)
remote_addr = Socket.pack_sockaddr_in(80, 'hao123.com')

begin
	socket.connect_nonblock(remote_addr)
rescue Errno::EINPROGRESS
	IO.select(nil, [socker])

	begin
		socket.connect_nonblock(remote_addr)
	rescue Errno::EISCONN
		# Success!
	rescue Errno::ECONNREFUSED
		# Refused by remote host
	end
end