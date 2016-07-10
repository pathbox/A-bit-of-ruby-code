require 'socket'

one_kb = 1024

Socket.tcp_server_loop(4481) do |connection|
	while data = connection.read(one_kb) do
		puts connection
		puts data        # 循环读取connection中的数据。每次读取1024 字节直到结束. Blocking Nature  it is blocking
	end

	connection.close
end

# will actually have the server printing data while the netcat command is still running. The data will be printed in one-kilobyte chunks.
# The difference in this example is that we passed an integer to read . This tells it to stop reading and return what it has only once it 
# has read that amount of data. Since we still want to get all the data available, we just loop over that read method calling it until it doesn't return any more data.

# A call to read will always want to block and wait for the full length of data to arrive. Take our above example of reading one kilobyte at a time.
#  After running it a few times, it should be obvious that if some amount of data has been read, but if that amount is less than one kilobyte, 
#  then read will continue to block until one full kilobyte can be returned.