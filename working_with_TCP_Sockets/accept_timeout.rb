require 'socket'
require 'timeout'

timeout = 5
server = TCPServer.new(4481)

begin
	server.accept_nonblock
rescue Errno::EAGAIN
	if IO.select([server], nil, nil, timeout)
		retry
	else
		raise Timeout::Error
	end
end