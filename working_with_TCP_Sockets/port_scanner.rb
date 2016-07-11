require 'socket'

PORT_RANGE = 1..512
HOST = 'achive.org'
TIME_TO_WAIT = 5

sockets = PORT_RANGE.map do |port|
	socket = Socket.new(:INET, :STREAM)
	remote_addr = Socket.pack_sockaddr_in(port, HOST)
	begin
		socket.connect_nonblock(remote_addr)
	rescue Errno::EINPROGRESS
	end

	socket
end

expiration = Time.now + TIME_TO_WAIT

loop do

	_, writable,_ = IO.select(nil, sockets, nil, expiration - Time.now)
	break unless writable

	writable.each do |socket|
		begin
			socket.connect_nonblock(socket.remote_address)
		rescue Errno::EISCONN
			puts "#{HOST}: #{socket.remote_address.ip_port} accepts connections..."
			sockets.delete(socket)
		rescue Errno::EINVAL
			sockets.delete(socket)
		end
	end
end