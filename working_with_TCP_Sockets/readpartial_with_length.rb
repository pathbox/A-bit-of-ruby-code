require 'socket'

one_hundred_kb = 1024 * 100

Socket.tcp_server_loop(4481) do |connection|
  begin
  	while data = connection.readpartial(one_hundred_kb) do  # it is not blocking
  		puts connection
  		puts data
  	end
  rescue EOFError
  ensure
  	connection.close
  end
end

# To recap, read is lazy, waiting as long as possible to return as much data as possible back to you. 
# Conversely, readpartial is eager, returning data to you as soon as its available.