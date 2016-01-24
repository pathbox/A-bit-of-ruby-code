#io = IO.popen("../temp/2015.log","r+")
#io.puts("this is a test io to io.txt")
#io.close_write
#list = check.readlines
#puts list.size
#将启动一个新的ruby实例。代码块将作为两个独立的进程进行，不像fork那样运行。子进程获得传递给代码块的nil，父进程获得一个IO对象，子进程的标准输入输出连接到该对象
IO.popen("-") do |mypipe|
  if mypipe
    puts "I am the parent: pid = #{Process.pid}"
    10.times do 
      sleep 0.01
      puts "I am the parent"
    end
    listen = mypipe.gets
    puts listen
  else
    puts "I am the child: pid = #{Process.pid}"
   # 10.times do
   #   sleep 0.1
   #   puts "I am the child"
   # end
  end
end

pipe = IO.pipe

reader = pipe[0]
writer = pipe[1]

str = nil
thread1 = Thread.new(reader,writer) do |r,w|
  str = r.gets
  r.close
end

thread2 = Thread.new(reader,writer) do |r,w|
  w.puts("hello! how are you ? ")
  w.close
end
thread1.join
thread2.join
puts str

arr = IO.readlines("../temp/2015.log") #将整个文件内容读取到内存中 产生一个数组结构
lines = arr.size
puts "myfile has #{lines} lines in it"
longest = arr.collect{|x|x.length}.max
puts "The longest line in it has #{longest} characters"
puts arr.class
str = IO.read("../temp/2015.log") #大型字符串
bytes = arr.size
puts "read: my file has #{bytes} bytes in it" 
puts str.class

# foreach 每次一行的方式读取
ary = Array.new
IO.foreach("../temp/2015.log") do |line| #each or eachline is the same action with foreach
 ary << line
end
puts "ary length " <<  ary.size.to_s

