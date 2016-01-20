require 'thread'

q = SizedQueue.new(20)

producer = Thread.new do 
  100.times do |i|
    q.push(i)
    sleep 0.1
  end
  q.push(nil)
end

consumer = Thread.new do 
  loop do
    i = q.pop
    break if i == nil
    puts i
  end
end

consumer.join
