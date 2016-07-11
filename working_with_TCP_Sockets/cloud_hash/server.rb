require 'socket'

module CloudHash
	class Server
		def initialize(port)
			@server = TCPServer.new(port)
			puts "Listening on port #{@server.local_address.ip_port}"
			@storage ={ }
		end

		def start
			Socket.accept_loop(@server) do |connection|
				handle(connection)
				connection.close
			end
		end

		def handle(connection)
			request = connection.read           # 读取请求，读取完处理，处理完写会socket，返回给client。然后close，完成一次操作
			connection.write process(request)
		end

		def process(request)
			command, key, value = request.split
			case command.upcase
			when 'GET'
				@storage[key]
			when 'SET'
				@storage[key] = value
			end
		end
	end
end

server = CloudHash::Server.new(4481)
server.start