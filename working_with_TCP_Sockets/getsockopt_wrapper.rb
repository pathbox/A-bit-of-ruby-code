require 'socket'

socket = TCPSocket.new('hao123.com', 80)

opt = socket.getsockopt(:SOCKET, :TYPE)