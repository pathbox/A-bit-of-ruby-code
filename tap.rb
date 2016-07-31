class Object
  def tap
    yield self
    yield
  end
end

temp = ['a','b','c'].push('d').shift
puts temp
x = temp.upcase.next
p x

['a','b','c'].push('d').shift.tap {|x| puts x}.upcase.next