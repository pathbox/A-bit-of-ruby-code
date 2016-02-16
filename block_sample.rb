def call_block
  puts "start"
  yield "foobar" if block_given?
  puts "end"
end

def call_block2(&block)
  puts "start"
  block.call("foobar")
  puts "end"
end

call_block do |str|
  puts "here"
  puts str
  puts "here"
end

# start
# here
#   foobar
# here
# end

f = File.open("myfile.txt", 'w')
f.write("Lorem ipsum dolor sit amet")
f.write("Lorem ipsum dolor sit amet")
f.close

# using block
File.open("myfile.txt", 'w') do |f|
  f.write("Lorem ipsum dolor sit amet")
  f.write("Lorem ipsum dolor sit amet")
end

# with code block

def send_message(msg)
  connection do |socket|
    socket.puts "foobar"
    socket.gets
  end
end

def connection
  socket = TCPSocket.new(@ip, @port)
  yield socket         # 用块的方式把外层的参数 闭包传到块里面
  ensure
    socket.close
  end
end
