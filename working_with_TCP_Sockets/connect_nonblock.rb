require 'socket'

socket = Socket.new(:INET, :STREAM)
remote_addr = Socket.pack_sockaddr_in(80, 'hao123.com')

begin
	socket.connect_nonblock(remote_addr)

rescue Errno::EINPROGRESS
	# Operation is in progress
rescue Errno::EALREADY

rescue Errno::ECONNREFUSED

end
