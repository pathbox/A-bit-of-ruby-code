require 'thread'

q = Queue.new

producer = Thread.new{
  100.times do |i| 
    q.push(i)
    sleep 0.1
  end
  q.push(nil)
}

consumer = Thread.new{
  loop{
    i = q.pop
    break if i == nil
    puts i
  }
}
consumer.join
