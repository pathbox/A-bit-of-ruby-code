require 'socket'

module CloudHash
	class Client
		class << self
			attr_accessor :host, :port
		end

		def self.get(key)
			request "GET #{key}"
		end

		def self.set(key, value)
			request "SET #{key} #{value}"
		end

		def self.request(string)
			@client = TCPSocket.new(host, port)  # new 一个TCPSocket 而不是 TCPServer，TCPServer没有write和read方法，只是用来构建一个tcp的host和port
			@client.write(string)  # 往服务端 write 字符串流

			@client.close_write  # 关闭这次write操作
			@client.read         # 从 TCPSocket中读取服务端返回的数据，read操作不手动close
			# @client.close_read 这一句不能加，会导致没有输出
		end
	end
end

CloudHash::Client.host = 'localhost'
CloudHash::Client.port = 4481

puts CloudHash::Client.set 'name', 'Curry'
puts CloudHash::Client.get 'name'
puts CloudHash::Client.get 'vp'