require "benchmark"

num_rows = 100000
num_cols = 10
data = Array.new(num_rows) { Array.new(num_cols) { "x"*1000 } }

time = Benchmark.realtime do csv = data.map do |row|
	  row.join(",")
  end.join("\n")
end

puts time

# I made the map block more verbose to show you where the problem is.
# The CSV rows that we generate inside that block are actually intermediate results stored
# into memory until we can finally join them by the newline character.
# This is exactly where we use that extra 1 GB of memory.