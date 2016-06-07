require "benchmark"

num_rows = 100000
num_cols = 10
data = Array.new(num_rows) { Array.new(num_cols) { "x"*1000 } }

time = Benchmark.realtime do
	csv = ''
	num_rows.times do |i|
		num_cols.times do |j|
			csv << data[i][j]
			csv << "," unless j == num_cols - 1
		end
		csv << "\n" unless i == num_rows - 1
	end
end

puts "%d MB" % (`ps -o rss= -p #{Process.pid}`.to_i/1024)
puts time

# But in my experience there’s often no need to optimize anything other than memory.
# For me the following 80-20 rule of Ruby performance optimization is always true: 80% of performance
# improvements come from memory opti- mization, the remaining 20% from everything else.