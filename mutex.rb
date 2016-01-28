# mutex 互斥锁sample实现
#
require 'thread'

puts "Synchronize Thread"

@num = 200
@mutex = Mutex.new  #并发写操作的时候，为了线程安全问题，需要加锁方式，读操作其实可以不用加锁

def buy num
  #@mutex.lock
  @mutex.synchronize do
  if @num >=num
	@num = @num - num
	puts "you have successfully bought #{num} tickets"
	puts "now : #{@num}"
  else
	puts "sorry no enough tickets"
  end
  end
  #@mutex.unlock
end

t1 = Thread.new 10 do
 10.times do |value|
   num = 15
   buy num
   sleep 0.3
 end
end

t2 = Thread.new 10 do
  10.times do |value|
	num = 10
	buy num
	sleep 0.1
  end
end
sleep 3
t1.join
t2.join
