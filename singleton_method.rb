obj = "abc"

class << obj
  def my_singleton_method
  "x"
  end
end

p obj.my_singleton_method