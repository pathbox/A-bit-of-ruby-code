require 'socket'

socket = TCPSocket.new('hao123.com', 80)

opt = socket.getsockopt(Socket::SOL_SOCKET, Socket::SO_TYPE)

p opt.int == Socket::SOCK_STREAM
p opt.int == Socket::SOCK_DGRAM
