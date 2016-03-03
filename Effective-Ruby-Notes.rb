# **************These notes are from 《Effective Ruby》********************
# ************************************************************************


# if person eq unless.nil? so you can not use nil?

# Array#compact delete all nil in  array
name = ["Stephen",nil,"Curry"].compact.join(" ")
# =~ 如果匹配到，它会返回字符串被右操作对象匹配到的位置。 使用match 方法替代
# if message =~ /^ERROR:\s+/  m = message.match(/^ERROR:\s+/); m[1]

# 三种 freeze

NETWORKS = ["192.168.0.1", "192.168.0.2"].freeze # 普通冻结常量数组, 不能增加或删除数组元素, 但可以修改数组内某个元素
NETWORKS = ["192.168.0.1", "192.168.0.2"].map!(&:freeze).freeze # 冻结数组 + 冻结数组中的所有元素, 这个常量就不能再修改了
module Defaults
  TIMEOUT = 5
end
Defaults.freeze  #冻结这个module

$VERBOSE = true  # 可以看所有警告信息


# module 和 class 除了一点以外其他方面都是相同的。module也是对象，并且是一个特定类的实例。类是class的实例，而模块是类module的实例。
# Ruby在内部实现module和类使用了相同的数据结构，但限制了通过它们的类方法能做的事情(module没有new方法)

# 当使用include方法来将module引入类时, Ruby在幕后悄悄地做了些事情。它创建了一个单例类并将它插入类体系(成为父类)中。这个匿名的不可见类被链向这个module，
#因此它们共享了实例方法和常量。单例类是匿名而不可见的，所以superclass和class方法都会跳过它。

# 当你想继承体系中的一个方法时，super可以帮你调用它
# super 和super() 不一样。super相当于传递了所有参数，super()是传递空参数

class Parent
  def initialize(name)
    @name = name
  end
end
# 使用super, 可以继承父类的initialize, 要不之类的initialize会覆盖父类的initialize
class Child < Parent
  def initialize(name, grade)
    super(name) # Initialize Parent
    @garde = garde
  end
end

# 使用 Person = Struct.new(:name, :age) 代替hash. Struct 可以使用block

Reading = Struct.new(:date, :high, :low) do
  def mean
    (high + low) / 2
  end
end

# 命名空间是一种保证常量唯一性的方法。其最基本的功能是创建作用域从而定义互不冲突的常量。
# 由于类和模块的名字是常量，因此命名空间能用来很好地隔离它们。
# 这在大型应用程序和库中作为代码隔离和模块化得一种方式
module Notebooks
  class Binding
    #.....
  end
end
style = Notebooks::Binding.new

# 类变量是在类中具有全局性的。而不是通过类变量在每个需要它的方法中传来传去。变量和实例变量才适合做这个



















































