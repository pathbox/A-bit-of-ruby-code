require 'thread'
array = []
mutex = Mutex.new
5.times.map do
  Thread.new do
    mutex.synchronize do
      1000.times do
        array << nil
      end
    end
  end
end.each(&:join)

puts array.size  # 5000

# 使用了一个共享的互斥或者说锁。一旦一个线程进入mutex.synchronize内的代码块时,所有其他线程必须在进入同一
# 代码前等待,直到这个线程执行完毕。线程调度上下文切换可以发生在任意两行代码间。
# 通过原子性操作,你可以保证如果一个上下文切换在这个代码块里发生了,其他线程将无法执行相同的代码。线程调度器会观察这一点,
# 并再切换另一个线程。这同样也保证了没有线程可以一同进入代码块并各自改变“世界”的状态。这个例子现在就是线程安全的。