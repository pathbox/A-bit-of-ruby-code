require 'socket'
require 'timeout'

timeout = 5
socket = Socket.new(:INET, :STREAM)
remote_addr = Socket.pack_sockaddr_in(80, 'hao123.com')

begin
	socket.connect_nonblock(remote_addr)
rescue Errno::EINPROGRESS
	# Indicates that the connect is in progress. We monitor the
	# socket for it to become writable, signaling that the connect
	# is completed.

	# Once it retries the above block of code it
	# should fall through to the EISCONN rescue block and end up
	# outside this entire begin block where the socket can be used.
	if IO.select(nil, [socket], nil, timeout)
		retry
	else
		raise Timeout::Error
	end

rescue Errno::EISCONN
	# Indicates that the connect is completed successfully.
end

socket.write("ohai")
socket.close