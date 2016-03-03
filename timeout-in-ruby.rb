# MRI 中 Timeout 的实现, 原理比较简单, lib/timeout 中就 100 多行, 核心代码如下:

bl = proc do |exception|
  begin
    x = Thread.current
    y = Thread.start {
      begin
        sleep sec
      rescue => e
        x.raise e
      else
        x.raise exception, message
      end
    }
    return yield(sec)
  ensure
    if y
      k.kill
      y.join # Make sure y is dead
    end
  end
end

# 将当前线程赋值给 x
# 创建一个线程 y, sleep n 秒, n 为 timeout 的时长; 执行 x 中 timeout 传入的 block
# 若 x 的 block 先结束, 则使用 Thread#kill 杀死 y 线程
# 若 y 的 sleep 先结束, 则使用 Thread#raise 使 x 抛出异常

def timeout(sec, exception = ERROR)
  return yield if sec == nil || sec.zero?
  raise ThreadError, "timeout within critical session" if Thread.critical
  begin
    x = Thread.current
    y = Thread.start {
      sleep sec
      x.raise exception, "excution expired" if x.alive?
    }
    yield sec
    #  return true
  ensure
    y.kill if y && y.alive?
  end
end