require 'forwardable'

class QueueList
  extend Forwardable

  def initialize
    @q = [] # Array.new, Queue.new
  end
  def_delegator :@q, :push, :enq  # enq method delegator push
  def_delegator :@q, :shift, :deq # deq method delegator shift

  # support some general Array methods that fit Queues well
  def_delegators :@q, :clear, :first, :push, :shift, :size  #@q can delegator these methods from Array
  # @q 即QueueList.new 能够使用Array的上面定义代理的几种实例方法
end

q = QueueList.new
q.enq 1, 2, 3, 4, 5
q.push 6
p q
q.shift
p q
p "lala#{q.deq}"
p q
q.enq "Ruby", "Perl", "Python"
q.push "Java", "C"
p q
q.clear
p q
puts q.first