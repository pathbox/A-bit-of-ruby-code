require 'mathn'
  list = []
  gen = Prime.new
  100.times {list << gen.succ}
  p "100 prime number array\n"
  p list

  class Integer
    def prime?
      max = Math.sqrt(self).ceil
      max -= 1 if max % 2 == 0
      pgen = Prime.new
      pgen.each do |factor|
        return false if self % factor == 0
        return true if factor > max
      end
    end
  end

