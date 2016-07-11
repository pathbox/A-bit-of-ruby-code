require 'socket'

server = TCPServer.new(4481)

loop do
	begin
		connection = server.accept_nonblock
	rescue Errno::EAGAIN
		# do other important work
		retry
	end
end