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

# clone 和 dump 返回的是浅拷贝, Marshal.load(Marshal.dump(a)) 返回的是深拷贝
# 对象副本会持有自身的内存空间,Marshal::dump在序列化创建的字节流也是会占用内存。

# map 已经可以被pluck或reduce给取代了. map很多时候不是一个性能最佳的使用
users.select{|u| u.age >= 21}.map(&:name)
users.reduce([]) do |names, user|
  names << user.name if user.age >= 21
  names
end

# define_method 只针对类和模块,对于对象我们可以使用define_singleton_method

class AuditDecorator
  def initialize(object)
    @object = obkect
    @logger = Logger.new($stdout)
    @object.public_methods.each do |name|
      define_singleton_method(name) do |*args, &block|
        logger.info("calling '#{name}' on #{@object.inspect}")
        @object.send(name, *args, &block)
      end
    end
  end
end

# eval 方法和其他解释性语言功能类似---在运行时执行一段用字符串拼接而成的合法的Ruby代码。
# 当然这是一种非常危险的操作，尤其是对于那些处理不可信数据的应用程序。
# Kernel模块定义了一个私有方法binding, 它可以捕获当前的临时域并把这个临时域封装到一个Binding(绑定)对象中
# 作为返回结果。这个指定的上下文是eval方法的第二个参数

def glass_case_of_emotion
  x = "I am in a #{__method__.to_s.tr('__',' ')}"
  binding
end
# binding让eval找到了x
eval("x", glass_case_of_emotion)  # => "I am in a glass case of emotion"

# 使用instance_eval 可以访问它的实例变量和已经定义的方法
w = Strinrg.new("Muffler Bearing")
w.instance_eval{@name} # => Muffler Bearing

# 使用instance_eval生成类方法. 同样的 class_eval也可以

String.instance_eval do
  def say_hi
    "Hallo"
  end
end

String.say_hi # => "Hallo"

# Forwardable模块,它将一个存有要代理的方法的链表绑定到一个实例变量上。def_delegators 方法将会产生一些实例方法，
# 这些实例方法会直接将请求的消息传递给目标对象。使用委托我们需要特别指定那些我们想通过公共接口暴露的方法。使用继承我们会继承所有父类的方法
# 事实上并不需要所有父类的方法都继承,而是需要部分父类方法。这时候使用委托是好的选择
# 举例：把RaisingHash#erase!方法转发给@hash.delete
# self.erase! to @hash.delete
def_delegator(:@hash, :delete, :erase!)
# 在设置完要委托方法后要确保initialize方法创建了在代理声明中指定的实例变量
def initialize
  @hash = Hash.new do |hash, key|
    raise(KeyError, "invalid key '#{key}' ")
  end
end

# StringExtra 类拥有String类所有的共有方法
require 'forwardable'
class StringExtra
  extend(Forwardable)
  def_delegator(:@string, *String.public_instance_methods(false))

  def initialize(str = "")
    @string = str
  end
  def only_space?
    #...
  end
end

# 使用refinement实现猴子补丁。refine只接受类作为参数
module OnlySpace
  refine(String) do
    def only_space?
      #...
    end
  end
end
# 在要使用的地方 using(OnlySpace)激活这个refinement。你可以在脚本开始的位置激活,也可以在类或者模块里激活
# using只接受包含refinement代码的模块(这里是OnlySpace)。这也是refinement比猴子补丁更安全的原因。猴子补丁的修改是全局可见的
# refinement可以自动在可见域之外让修改失效。
class Person
  using(OnlySpace)
  def initialize(name)
    @name = name
  end
  def valid?
    @name.only_space?
  end
end

# 你定义了一个继承自Person的Customer类,那在之类是否就无法使用only_space?方法?之类Coustomer实例是可以调用valid?方法，
# 因为valid?方法定义在Person类中。但是在Customer类中直接定义的方法将无法使用only_space?方法,实例变量也不能直接使用only_space?方法，除非refinement在Customer类中被
# 再次激活。

# 使用模块前置时请谨慎思考
# 我们从Ruby内部结构了解到向类引入模块实际上改变了类的继承结构。当一个类在include模块内时,Ruby会创建一个单例类来保存模块中的方法
# 并把这个类作为不可见的父类。当一个类有多个模块时，会倒序搜索方法。

module A
  def who
    "A#who"
  end
end

module B
  def who
    "B#who"
  end
end

class C
  include A
  include B
  def who
    "C#who"
  end
end

C.ancestors # => [C, B, A, Object, Kernel, BasicObject]
C.new.who
#include方法会在类C和它的父类之间插入模块，所以相比A模块而已，B模块会先被搜索。
#基于ancestors的输出结果，调用super它将会执行B模块的who方法。module的优先级会大于之类的父类方法，并且按照include顺序倒序排序搜索，所以B 优先于 A
class D
  prepend A
  prepend B
  def who
    "D#who"
  end
end
D.ancestors # => [B, A, D, Object, Kernel, BasicObject] # include 的module 将在本身类D之前。类中的方法无法覆盖module中的方法
# prepend 可以用alias_method 方法实现类似效果。
# prepend 将模块插入到接收者之前。include 将模块插入到接收者和其超类之间。

# MiniTest
class VersionTest < MiniTest::Unit::TestCase
  def setup  # 初始化测试数据
    @v1 = Version.new("2.1.1")
  end
  def test_major_number # use test_ start
    v = Version.new(1,2,3)
    assert(v.major == 2, "major should be 2")
    assert_equal(2, v.major, "major")
    assert_equal(1, v.minor, "minor")
  end
end
# rake test 运行所有测试
# 使用describe方法创建测试类，使用it定义测试用例
# 虽然在需求说明测试中，断言仍然可用，但是更推荐使用注入到Object中的期望方法










































