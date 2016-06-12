require 'benchmark'

obj = "sample"

time = Benchmark.realtime do
	100000.times do
		obj.is_a?(String)   # better way
	end
end

puts time