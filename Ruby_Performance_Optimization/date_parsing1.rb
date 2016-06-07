require 'date'
require 'benchmark'

date = "2014-05-23"
time = Benchmark.realtime do
	100000.times do 
		Date.parse(date)
	end
end
puts "%.3f" % time

#0.650