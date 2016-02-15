require 'thread'
mutex = Mutex.new

cv = ConditionVariable.new
a = Thread.new {
     mutex.synchronize {
        puts "A: I have critical section, but will wait for cv"
		      cv.wait(mutex)
			        puts "A: I have critical section again! I rule!"
					   }
}

puts "(Later, back at the ranch...)"

b = Thread.new {
     mutex.synchronize {
        puts "B: Now I am critical, but am done with cv"
		      cv.signal
			        puts "B: I am still critical, finishing up"
					   }
}
a.join
b.join

#以上实例输出结果为：
#A: I have critical section, but will wait for cv
#(Later, back at the ranch...)
#B: Now I am critical, but am done with cv
#B: I am still critical, finishing up
#A: I have critical section again! I rule!
