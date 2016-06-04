# Threads Ain’t Free

# The improved performance with multiple threads might lead one to believe that we can just keep adding more threads –
# basically infinitely – to keep making our code run faster and faster. That would indeed be nice if it were true,
# but the reality is that threads are not free and so, sooner or later, you will run out of resources.

# Let’s say, for example, that we want to run our sample mailer not 100 times, but 10,000 times. Let’s see what happens:

threads = []
puts Benchmark.measure{
	10_000.times do |i|
		threads << Thread.new do
			# ... do somthing
		end
	end
	threads.map(&:join)
}

# Boom! I got an error with my OS X 10.8 after spawning around 2,000 threads:

# can't create Thread: Resource temporarily unavailable (ThreadError)

# As expected, sooner or later we start thrashing or run out of resources entirely.
#  So the scalability of this approach is clearly limited.
# run out of resources




























# Nice Way. Using The Queue to make a thread pool
POOL_SIZE = 10

jobs = Queue.new

10_0000.times{|i| jobs.push i}

workers = (POOL_SIZE).times.map do
	Thread.new do
		begin
			while x = jobs.pop(true)
				# ... do something
			end
		rescue ThreadError
			logger.debug "Thread Error!"
		end
	end
end

workers.map(&:join)