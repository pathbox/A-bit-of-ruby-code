require 'socket'

Socket.tcp_server_loop(4481) do |connection|

	puts connection
	puts connection.read
	connection.close
end

# tail -f /var/log/system.log | nc localhost 4481