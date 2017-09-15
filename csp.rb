# concurrency-ruby

require 'concurrent-edge'

array = [1,2,3,4,5]
channel = Concurrent::Channel.new

Concurrent::Channel.go do
  puts "GO 1 thread: #{Thread.current.object_id}"
  channel.put(array[0..2].sum) # Enumerable#sum from Ruby 2.4
end

Concurrent::Channel.go do
  puts "Go 2 thread: #{Thread.current.object_id}"
  channel.put(array[2..4].sum)
end
puts "Main thread: #{Thread.current.object_id}"
puts channel.take + channel.take



# 我们在两个不同的线程中跑了两个操作（加法），在主线程中同步并且汇总了总值。所有这些都通过 Channel 完成而没有使用任何锁。 究其根本，每一个 Channel.go 都会在线程池中取一个独立的线程来跑，如果线程池中没有足够的空闲线程，它会自动的增加线程池的大小。 在这种有阻塞I/O的情况下，这种会释放GIl的处理是非常有用的（前一篇文章有更详细的介绍），另一方面，我们看看clojure中的core.async，它使用一个有限的数字来给线程编号，并且试图使他们‘寄停’（park），这样的处理可能会导致I/O操作阻塞了其他的操作

# https://chenxiyu.github.io/2017/09/09/Introduction_to_Concurrency_Models_with_Ruby_Part_II/