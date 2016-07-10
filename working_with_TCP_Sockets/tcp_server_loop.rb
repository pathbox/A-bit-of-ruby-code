require 'socket'

# The granddaddy of the Ruby wrappers is Socket.tcp_server_loop , 
# it wraps all of the previous steps into one:


Socket.tcp_server_loop(4481) do |connection|
	puts connection
	connection.close
end