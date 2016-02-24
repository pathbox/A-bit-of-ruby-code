#替换方法　Replacing methods

#有时候一个方法的实现不是你要的，或者只做了一半。
# 标准的面向对象方法是继承并重载，再调用父类方法。
# 仅当你有对象实例化的控制权时才有用，经常不是这种情况，继承也就没有价值。
# 为得到同样的功能，可以重命名（alias）旧方法，并添加一个新的方法定义来调用旧方法，并确保旧方法的前后条件得到保留。

class String
  alias_method :original_reverse, :reverse  # alias_method :new_name_for_old_def, :old_to_new_def
  def reverse
    puts "reversing, please wait..."
  end
end

"dog".reverse  # reversing, please wait...
"dog".original_reverse # god

# 原来 String 只有 reverse方法没有original_reverse方法。
# 使用alias_method后, original_reverse 代替并保留reverse方法的功能(相当于reverse方法的重命名), reverse实现代码中新更改后的功能