require "benchmark"

num_rows = 100000
num_cols = 10
data = Array.new(num_rows) {Array.new(num_cols){ "x"*1000}}

puts "%d MB" % (`ps -o rss= -p #{Process.pid}`.to_i/1024)

GC.disable  # data 没有被回收, 下面的执行将快很多, 因为减少了GC的时间。然而, 这个文件代码持续占用内存时间会长.
time = Benchmark.realtime do
	csv = data.map{ |row| row.join(",") }.join("\n")
end

puts "%d MB" % (`ps -o rss= -p #{Process.pid}`.to_i/1024)
puts time


# 1060 MB
# 2449 MB
# 1.9927548820051015

# Aha. Things are getting more and more interesting. Our initial dataset is roughly 1 gigabyte.
#  Here and later in this book when I write kB I mean 1024 bytes, MB - 1024 * 1024 bytes, GB - 1024 * 1024 * 1024 bytes 
#  (yes, I know, it’s old school). So, we consumed 2 extra gigabytes of memory to process that 1 GB of data. Your gut feeling 
#  is that it should have taken only 1 GB extra.
#  Instead we took 2 GB. No wonder GC has a lot of work to do!


# • Memory consumption and garbage collection are among the major reasons why Ruby is slow.
# • Ruby has a significant memory overhead.
# • GC in Ruby 2.1 and later is up to five times faster than in earlier versions.
# • The raw performance of all modern Ruby interpreters is about the same.