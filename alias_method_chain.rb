# rails 中为了能够实现类型装饰模式的行为,基于上面的这个 alias_method 做了一个 alias_method_chain 的方法,
# 它的作用就是能够在原本执行的方法前后加上一些起装饰作用的代码.


# require 'active_support'
# class A
#   def m1
#     puts 'here run m1'
#   end
#   def m1_with_m2
#     puts "do something before m1"
#     m1_without_m2
#     puts "do something after m2"
#   end
#   alias_method_chain :m1, :m2
# end
# #=> A
# a = A.new
# # => #<A:0xb7bd9820>
# a.m1
# # do something before m1
# # m1
# # do something after m2
# # => nil

class Klass
  def salute
    puts "Aloha!"
  end
  def salute_with_log
    puts "Calling method..."

    salute_without_log # def salute; end

    puts "...Method called"
  end

  alias_method :salute_without_log, :salute
  alias_method :salute, :salute_with_log
  # alias_method_chain :salute, :log
end

Klass.new.salute
Klass.new.salute_without_log # => Aloha!
# Calling method...
# Aloha!
# ...Method called

# 这时候salute_without_log方法表示原始的salute方法
# 现在的salute方法和salute_with_log方法都执行salute_with_log这个新的方法代码