# require 'active_support'
# class A
#   def m1
#     puts 'here run m1'
#   end
#   def m1_with_m2
#     puts "do something befor m1"
#     m1_without_m2
#     puts "do something after m2"
#   end
#   alias_method_chain :m1, :m2
# end
# #=> A
# a = A.new
# # => #<A:0xb7bd9820>
# a.m1
# # do something befor m1
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