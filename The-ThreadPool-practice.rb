# This practice is about TreadPool, and how to use it.
require 'thread'
require 'set'
class ThreadPool
  def initialize(size: )
    @size = size
    #@jobs = Queue.new
    @jobs = SizedQueue.new(10)
    @pool = Array.new(size) do # 新建size个线程,保存在数组中
      Thread.new do
        catch(:exit) do  # 当throw :exit时, stop loop
          loop do    # 每个thread不断的loop,把队列中的闭包取出,执行其中的代码程序
            job, args = @jobs.pop
            job.call(*args)
          end
        end
      end
    end
  end

  def schedule(*args, &block)
    @jobs << [block, args]    # 将要执行的block代码和参数args存入队列Queue(将一个闭包存入队列)
  end                         # 这就像是在处理抢购或高并发操作时,将代码存入队列,防止线程安全问题

  def shutdown  #最后需要执行的
    @size.times do
      schedule{ throw :exit }
    end
    @pool.map(&:join)
  end

end

def test_pool_size_limit
  pool_size = 5
  pool = ThreadPool.new(size: pool_size)
  mutex = Mutex.new
  threads = Array.new

  100000.times do
    pool.schedule do
      mutex.synchronize do
        puts "hello"
        threads << Thread.current
      end
    end
  end
  puts [threads.uniq, threads.size] # just one thread, but << threads array many times
  pool.shutdown
end
# test_pool_size_limit

def test_time_taken
  t = Time.now
  pool_size = 5
  pool = ThreadPool.new(size: pool_size)
  100.times do
    pool.schedule { sleep 1 }
  end
  pool.shutdown
  p Time.now - t
end
test_time_taken