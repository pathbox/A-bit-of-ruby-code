require 'socket'
require 'timeout'

timeout = 5

Socket.tcp_server_loop(4481) do |connection|
	begin
		# Initiate the initail read(2). This is important because
		# it requires data be requested on the socket and circumvents
		# a select(2) call when there's already data available to read.
		connection.read_nonblock(4096)
	rescue Errno::EAGAIN
		# Monitor the connection to see if it becomes readable
		if IO.select([connection], nil, nil, timeout)
			# IO.select will actually return out socket, but we
			# don't care about the return value. The fact that
			# it didn't return nil means that our socket is readable.
			retry
		else
			raise Timeout::Error
		end
	end
	connection.close
end