array = []
100_000_000.times do |i|
  array << i
end

ram = Integer(`ps -o rss= -p #{Process.pid}`) * 0.001
puts "Process: #{Process.pid}: #{ram} mb"

Process.fork do
  ram = Integer(`ps -o rss= -p #{Process.pid}`) * 0.001
  puts "Process: #{Process.pid}: #{ram} mb"
end

# Process: 99526: 788.584 mb
# Process: 99530: 1.032 mb

# You’ll notice however, that going from four processes to three won’t cut your memory use by one fourth.
# This is because modern versions of Ruby are Copy on Write friendly.
# That is, multiple processes can share memory as long as they don’t try to modify it.
# This is a contrived example that shows forked processes are smaller. In the case of Puma, forked workers will be smaller but certainly not by a factor of 1/788.
# "Running with fewer workers has downsides — most importantly, your throughput will go down. If you don’t want to run with fewer workers,
# then you’ll need to find hotspots of object creation and figure out how to get around them