connections = [<TCPSocket>,<TCPSocket>,<TCPSocket>]

loop do

	connections.each do |conn|
		begin
			data = conn.read_nonblock(4096)
			process(data)
		rescue Errno::EAGAIN
		end
	end
end