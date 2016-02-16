# The codes show how to use ruby to build the awesome APIs and skills for programmer in the file.
# Many nice meta-programmer functions and skills show to you

def call_block
  puts "start"
  yield "foobar" if block_given?
  puts "end"
end

def call_block2(&block)
  puts "start"
  block.call("foobar")
  puts "end"
end

call_block do |str|
  puts "here"
  puts str
  puts "here"
end

# start
# here
#   foobar
# here
# end

f = File.open("myfile.txt", 'w')
f.write("Lorem ipsum dolor sit amet")
f.write("Lorem ipsum dolor sit amet")
f.close

# using block
File.open("myfile.txt", 'w') do |f|
  f.write("Lorem ipsum dolor sit amet")
  f.write("Lorem ipsum dolor sit amet")
end

# with code block

def send_message(msg)
  connection do |socket|
    socket.puts "foobar"
    socket.gets
  end
end

def connection
  socket = TCPSocket.new(@ip, @port)
  yield socket         # 用块的方式把外层的参数 闭包传到块里面
ensure
  socket.close
end
end

# Dynamic Callback

server = Server.new

server.handle(/hello/) do
  puts "Hello at #{Time.now}"
end

server.execute("/hello")

# Self Yield

spec = Gem::Specification.new
spec.name = "foobar"
spec.version = "1.1.1"

# using block
Gem::Specfication.new do |s|
  s.name = "foobar"
  s.version = "1.1.1"
  # ...
end

class Gem::Specification
  def initialize name = nil, version = nil
    #...
    yield self if block_given?
    #...
  end
end

# Atrivial example Module

module Mixin
  def foo
    puts "foo"
  end
end

class A
  include Mixin
end
A.new.foo  # foo

A.extend(Mixin)

class A
  extend Mixin
end

class << A
  include Mixin # 单例的使用思想  Mixin#foo 变为了 A 直接调用的方法,因为A为class,所以foo 是A的类方法
end
A.foo # class method

a = "test"
a.extend(Mixin)
class << a
  include Mixin  #Mixin#foo 变为了 a 直接调用的方法,如果a为一个实例,则 foo 是 a的实例方法
end
a.foo # foo
b = "demo"
b.foo # NoMethodError

# Dual interface

module Logger
  extend self
  def log(msg)
    $stdout.puts "#{msg} at #{Time.now}"
  end
end

Logger.log("test")  # as Logger's class method

class MyClass
  include Logger
end
MyClass.new.log("test")  # as MyClass's instance method

# Mixin with class method

module Mixin
  def foo
    puts "foo"
  end

  module ClassMethods
    def bar
      puts "bar"
    end
  end
end

class MyClass
  include Mixin  # foo is instance method
  extend Mixin::ClassMethods # bar is class method
end

module Mixin
  # self.included is a hook method
  def self.included(base)
    base.extend(ClassMethods)
  end
  def foo
    puts "foo"
  end
  module ClassMthods
    def bar
      puts "bar"
    end
  end
end

class MyClass
  include Mixin # foo => instance method, bar => class method. include foo, included ClassMethods, extend bar
end

module Mixin
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end
  module InstanceMethods
    def foo
      puts "foo"
    end
  end
  module ClassMethods
    def bar
      puts "bar"
    end
  end
end

class MyClass
  include Mixin # foo is instance method, bar is class method
end

# method_missiong

class Car
  def go place
    puts "go to #{place}"
  end

  def method_missing(name, *args)
    if name.to_s =~ /^go_to_(.*)/
      go($1)  # $1 : name.to_s
    else
      super
    end
  end
end

car = Car.new
car.go_to_beijing  # go to beijing
car.blah # NoMethodError: undefined method 'blah'

# dont't abuse method missing
# method_missing is slow
# only use it when you can not define method in advance
# Meta-programming can define methods dynamically


# XML builder example

builder = Builder::XmlMarkup.new(:target => STDOUT, :indent=>2)
builder.person do |b|
  b.name("Jim")
  b.phone("555-1234")
  b.address("Beijing, China")
end
#<person>
#  <name>Jim</name>
#  <phone>555-1234</phone>
#  <address>Beijing, China</address>
#</person>

[1,2,3,4,5].select{|i|i.odd?}.inject{|sum,i|sum+=i} #统计所有奇数的和

class Demo
  def foo
    puts "foo"
    self
  end
  def bar
    puts "baz"
    self
  end
  def baz
    puts "baz"
    self
  end
end

Demo.new.foo.bar.baz
# foo
# bar
# baz

# Object#tap

puts "dog".reverse
           .tap{|o| puts "reversed: #{o}"} # return original object
           .upcase
# output
# reversed: god
# GOD
# tap 有类似断点的作用

class Object
  def tap
    yield self # 回调block, 把self 闭包传入block
    self  #这样可以后面继续 send self 的方法
  end
end

# Numeric#bytes example

class Numeric
  KILOBYTE = 1024
  MEGABYTE = KILOBYTE * 1024
  GIGABYTE = MEGABYTE * 1024

  def bytes
    self
  end
  alias :byte :bytes
  def kilobytes
    self * KILOBYTE
  end
  alias :kilobyte :kilobytes
  def megabytes
    self * MEGABYTE
  end
  alias :megabyte :megabytes
  def gigabytes
    self * GIGABYTE
  end
  alias :gigabyte :gigabytes
end

# metaclass

class A
  def foo
  end
end

obj1 = A.new
obj2 = A.new

def obj2.bar
  # only obj2 has bar method, called singleton method
end

# another way
class << obj1
  def baz
    # only obj1 hash baz method
  end
end

#obj2 -> class ->
#                                        A -> super -> Object
#obj2 -> class obj2's metaclass -> super

class A
  def self.foo
  end
end

class << self
  def bar  # self method. whatever self is what, such as: class, instance, string, constant and so on. They can . or send :bar

  end
end

def A.baz
end

class Demo
  class << self
    # the current class is Demo's metaclass
    def foo

    end
  end
end
Demo.foo

# Meta-programming
# How to write code to write code?

# How to write a method to define method?

class Demo
  # the current class is Demo

  def define_blah1
    def blah1
      puts "blah1"
    end
  end

  class << self
    def define_blah2
      def blah2
        puts "blah2"
      end
    end
  end
end

Demo.new.blah1  # NoMethodError: undefined method 'blah1'
Demo.new.define_blah1
Demo.new.blah1  # blah1

Demo.new.blah2  # NoMethodError: undefined method 'blah2'
Demo.define_blah2
Demo.new.blah2  # blah2

# How to write a method to define singleton method?

class Demo
  def define_blah1
    # self if Demo's instance
    def self.blah1
      puts "blah1"  # define singleton method
    end
  end

  def self.define_blah2
    # self is Demo
    def self.blah2
      puts "blah2" # define singleton method (class method)
    end
  end
end

a = Demo.new
a.define_blah1  # first step
a.blah1 # blah1
Demo.new.blah1 # NoMethodError: undefined method 'blah1'

Demo.new.blah2 # NoMethodError: undefined method 'blah2'
Demo.define_blah2  # first step
Demo.blah2 # blah2

# The key of power is variable scope!!!

#block variable scope

var1 = "foo"

3.times do
  puts var
  var1 = "bar"
  var2 = "baz"
end
puts var1 # foo
puts var2 # NameError: undefined local variable or method

# define_method  unlike "def", you can access outside variable!!!

class Demo
  # define instance methods
  ["aaa","bbb","ccc"].each do |name|
    define_method(name) do
      puts name.upcase   # name is the outside variable
    end
  end

  #define class methods
  class << self
    ["xxx","yyy","zzz"].each do |name|
      define_method(name) do
        puts name.upcase   # name is the outside variable
      end
    end
  end
end

Demo.new.aaa # AAA
Demo.new.send(:bbb) # BBB

Demo.yyy # YYY
Demo.send(:zzz) # ZZZ

# define_method will defines instance method for current object it is must be class object or module
# So ublike "def" define_method will not create new scope

# So we maybe need those method inside define_method: because the scope is not changed
# Object#instance_variable_get
# Object#instance_variable_set
# Object#remove_instance_variable
# Module#class_variable_get
# Module#class_variable_set
# module#remove_class_variable

# Not dynamic enough? Because class << will create new scope still!!!


# class_eval  only for class object or module

var = 1
String.class_eval do

  puts var # 1
  puts self # the current object is String

  # the current class is String
  def foo  # String instance method
    puts "foo"
  end

  def self.bar # String class method
    puts "bar"
  end

  class << self
    def baz     # String class method
      puts "baz"
    end
  end
end

"abc".foo  # foo
String.bar # bar
String.baz # baz

# class_eval + define_method

name = "say"
var = "it's awesome"

String.class_eval do   # a closure mind and way
  define_method(name) do # String's instance method. "name" is outside variable
    puts var             # var is outside variable
  end
end

"nice awesome".sned("#{name}")  # it's awesome

# define singleton method using class_eval and define_method

# Wrong!!! ===================
name = "foo"
var = "bar"
String.class_eval do
  class << self
    define_method(name) do
      puts var
    end
  end
end

# ArgumentError: interning empty string
# we can not get name and var variable, because class << create new scope
# Wrong!!! =====================

# Fixed! you need find out metaclass and class_eval it!

name = "foo"
var = "bar"

metaclass = (class << String; self; end) # "foo", "bar" class is String. you need find name and var metaclass
metaclass.class_eval do
  define_method(name) do
    puts var
  end
end

String.send("#{name}")  # bar

# How about apply to any object? because class_eval only works on class object or module

# huhulala  instance_eval for any object

obj = "blah"
name = "awesome"
obj.instance_eval do
  puts self  # obj

  # the current class is obj's metaclass.(class << obj; self; end)
  def foo
    # puts name # you can get the outside variable name
    puts "foo"
  end
end
"blah".foo # NoMethodError: undefined method `foo' for "blah":String
obj.foo  # singleton method

# how about class object

String.instance_eval do
  puts self  # String

  # the current class is String's metaclass
  def foo
    puts "bar"
  end
end

String.foo  # singleton method (class method) bar

# Class Macro  Ruby's declarative style

class Demo
  class << self
    def say
      puts "blah"
    end
  end

  say # you can execute class method in class body
end

# Memorize examole

class Account
  def calculate
    @calculate ||= begin
      sleep 10
      5
    end
  end
end

a = Account.new
a.calculate # need waiting 10s to get 5
a.calculate # 5  don't need waiting 10s
a.calculate # 5  don't need waiting 10s
# ...  the  " ||= " help to don't need waiting 10s to get 5

# memorize method

class Account
  def calculate
    sleep 5
    5
  end
  memorize :calculate
end

a = Account.new
a.calculate # need waiting 10s to get 5
a.calculate # 5  don't need waiting 10s

class Class
  def memorize(name)
    original_method = "_original_#{name}"
    alias_method :"#{original_method}", name
    define_method name do
      cache = instance_variable_get("@#{name}")  # get the outside variable
      if cache
        return cache
      else
        result = send(original_method)  # Dynamic Dispatches
        instance_variable_set("@#{name}", result)
        return result
      end
    end
  end
end

# BTW  how to keep original method and call it later?

# alias_method  most common way  example above
# method binding  can avoid to add new method  example in const_missing

# instance_eval  DSL calls it create implicit context

# Rack example

Rack::Builder.new do
  use Some::Middleware, param
  use Some::Other::Middleware
  run Application
end

# How is instance_eval doing?
# It changes the "self"(current object) to caller
# Any object can call instance_eval(unlike class_eval)

class Demo
  def initialize
    @a = 99
  end
end

foo = Demo.new

foo.instance_eval do
  puts self  # foo instance
  puts @a  # 99
  #@a
end

# instance_eval with block

class Foo
  attr_accessor :a, :b
  def initialize(&block)
    instance_eval &block if block_given?
  end
  def use(name)
    # do something
  end
end

bar = Foo.new do
  self.a = 1
  self.b = 2
  use "blah"
  use "blahblah"
end

# anonymous class

klass = Class.new
  def move_left
    puts "left"
  end
end

object = klass.new
object.move_left  # left
Car = klass  # naming it Car  # 这里是一种设计模式的思想,忘了是哪个了
car = Car.new     # 似乎是工厂模式
car.move_left # left

# variable scope matters you can access outside variable

var = "it's awesome"
klass = Class.new
  puts var
  def my_method
    puts var  # undefined local variable or method 'var'
  end
  define_method :my_method do  # define_method can get outside variable var
    puts var  # it's awesome
  end
end
puts klass.new.my_method

# Parameterized subclassing example

def Person(name)
  if name == "awesome"
    Class.new do
      def message
        puts "good"
      end
    end
  else
    Class.new do
      def message
        puts "bad"
      end
    end
  end
end

class Foo < Person 'awesome'
  def name
    "foo"
  end
end

class Bar < Person 'bad'
  def name
    "bar"
  end
end

f = Foo.new
f.message  # good
b = Bar.new
b.message  # bad




















































