require 'thread'
a = 0
Thread.new{
  loop{
    a +=1
    puts "thread 1 "+a.to_s
    sleep 0.1
  }
}
Thread.new{
  loop{
    a+=1
    puts "thread 2 "+ a.to_s
    sleep 0.1
  }
}

loop{
  if a >  100
    Thread.exit
  end
  puts "main thread " + a.to_s
  sleep 0.1
}
