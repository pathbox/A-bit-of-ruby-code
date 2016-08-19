module ListStrings
  refine String do
    def +(other)
      "#{self}, #{other}"
    end
  end
end

using ListStrings
'4' + '5'
# => "4, 5"

eval "using ListStrings; '4' + '5'"
# => "4, 5"

module Foo
  refine Fixnum do
    def to_s
      :foo
    end
  end
end

class NumAsString
  def num(input)
    input.to_s
  end
end

class NumAsFoo
  using Foo
  def num(input)
    input.to_s
  end
end

NumAsString.new.num(4)
# => "4"
NumAsFoo.new.num(4)
# => :foo 
