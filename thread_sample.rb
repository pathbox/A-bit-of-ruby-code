require 'thread'

module ThreadSimple
	class PutNum
		def thread_example
			array = []
			s = 0
			100.times do |i|
				array[i] = Thread.new do
					sleep 0.1
					s += 1
					puts "hello#{i}"
				end
			end
			array.each {|t| t.join}
			puts "The s is #{s}"
		end

		def thread_race
			i = 0
			t1 = Thread.new do
				10000000.times do
					#sleep 0.1
				  i += 1
			  end
			end
			t2 = Thread.new do
				10000000.times do
					#sleep 0.1
				  i += 1
			  end
			end
			puts "The i is #{i}"
			t1.join
			t2.join
			puts "The i is #{i}"
		end

		def thread_mutex
			mutex = Mutex.new
			array = []
			s = 0
			mutex.synchronize do
				100.times do |i|
					array[i] = Thread.new do
						sleep 0.1
						s += 1
						puts "hello#{i}"
					end
				end
			end
			array.each{|a| a.join}
			puts "The s is #{s}"
		end
	end
end

#ThreadSimple::PutNum.new.thread_example  # just one thread, s eq 100
ThreadSimple::PutNum.new.thread_race
#ThreadSimple::PutNum.new.thread_mutex


















