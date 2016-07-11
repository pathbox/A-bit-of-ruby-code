require 'socket'

client = TCPSocket.new('localhost', 4481)

payload = 'Lorem ipsum' * 10_000

begin
	loop do
		bytes = client.write_nonblock(payload)
		break if bytes >= payload.size
		payload.slice!(0, bytes)
		IO.select(nil, [client])
	end
rescue Errno::EAGAIN
	IO.select(nil, [client])
	retry
end