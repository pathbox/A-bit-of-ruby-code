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

# 无论何时你有多个线程共享一个对象引用时，并对其做了修改，你就要有麻烦了，除非有锁来阻止修改中的上下文切换。
# 使用了一个共享的互斥或者说锁。一旦一个线程进入mutex.synchronize内的代码块时,所有其他线程必须在进入同一
# 代码前等待,直到这个线程执行完毕。线程调度上下文切换可以发生在任意两行代码间。
# 通过原子性操作,你可以保证如果一个上下文切换在这个代码块里发生了,其他线程将无法执行相同的代码。线程调度器会观察这一点,
# 并再切换另一个线程。这同样也保证了没有线程可以一同进入代码块并各自改变“世界”的状态。这个例子现在就是线程安全的。

# 然而，不在代码中使用显示锁，也能简单解决这种特定的竞争条件。这里有个Queue的解决方案。

require 'thread'

class Sheep
  # ...
end

sheep = Sheep.new
sheep_queue = Queue.new
sheep_queue << sheep

5.times.map do
  Thread.new do
    begin
      sheep = sheep_queue.pop(true)

      sheep.shear!
    rescue ThreadError
      # raised by Queue#pop in the threads
      # that don't pop the sheep
    end
  end
end.each(&:join)

# 因为没有变化，我忽略了Sheep的实现。现在，不在是每个线程共享sheep对象并竞争去薅它，队列提供了同步机制。
#我建议使用Queue作为锁的替代品，是因为它只简单地正确利用了队列。众所周知锁是很容易出错的。
# 一旦使用不当，它们就会带来像死锁和性能下降这样的担忧。利用依赖抽象的数据结构。它严格包装了复杂的问题，提供简便的API。

# 最终，GIL保证了MRI中C实现的原生Ruby方法执行的原子性（即便有些警告）。
# 这一行为有时可以帮助作为Ruby开发者的我们，但是GIL其实是为了保护MRI内部而设计的，对Ruby开发者没有可靠的API。
# 使用数据结构来提供同步机制；角色模型即是如此。这一理念也存在于Go,Erlang和其他一些语言的并发模型内核里。