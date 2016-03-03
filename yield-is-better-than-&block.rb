require 'benchmark'

def with_block(&block); block.call end
def with_yield;         yield      end

Benchmark.bm do |x|
  x.report('with &block') do
    1_000_000.times { with_block { 'hello, world' } }
  end

  x.report('with  yield')  do
    1_000_000.times { with_yield { 'hello, world' } }
  end
end

#user     system      total        real
#with &block  0.900000   0.010000   0.910000 (  0.913443)
#with  yield  0.210000   0.000000   0.210000 (  0.216074)

# 由于第二种方式在调用时每次都会生成一个 Proc 对象, 在性能上要比第一种方式慢数倍, 所以尽量不要使用, 除非你确定需要一个 Proc 对象.

# 另有一个好玩的 trick: 在方法内使用 Proc.new 若后面没有跟一个代码块, 这个 Proc 对象将会默认使用方法外部的代码块.

def say
  Proc.new.call
end
say { 'Hello, World!' }

# => 'Hello, World!'