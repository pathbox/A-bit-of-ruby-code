require 'socket'

Socket.tcp_server_loop(4481) do |connection|
	loop do
		begin
			puts connection.read_nonblock(4096)
		rescue Errno::EAGAIN
			IO.select([connection])
		rescue EOFError
			break
		end
	end

	connection.close
end