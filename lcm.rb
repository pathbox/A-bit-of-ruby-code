#计算两个整数的最小公倍数
#
require 'mathn'

class Integer
  def lcm(other)
    p1 = self.prime_division.flatten
    p2 = other.prime_division.flatten
    h1 = Hash[*p1]
    h2 = Hash[*p2]
    hash = h2.merge(h1){|k,old,new|[old,new].max}
    Integer.from_prime_division(hash.to_a)
  end

end
