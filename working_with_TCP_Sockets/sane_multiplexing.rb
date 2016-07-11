connections = [<TCPSocket>,<TCPSocket>,<TCPSocket>]

loop do
	ready = IO.select(connections)

	readable_connections = ready[0]
	readable_connections.each do |conn|
		data = conn.readpartial(4096)
		process(data)
	end
end