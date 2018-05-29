# https://speakerdeck.com/rickliu/functional-programming-concepts

# PROC
add = Proc.new { |x, y| x + y }

# Kernel#proc
add = proc { |x, y| x + y }

# Kernel#lambda
add = lambda { |x,y| x + y }
# => #<Proc:0x0000001211c620@(pry):2 (lambda)>

# stabby lambda
add = -> x, y { x + y }

# Block anonymous function

def capture_block(&block)
  # a new proc is created
  block.call
end

capture_block { puts " Inside the block "}


# Method as object
class Cat
  def talk
    puts "self is #{self}"
  end
end

c = Cat.new

m = c.method(:talk)

m.call


# calling callable objects

add = -> x, y { x + y }

add.call(1, 2)

add.(1.2) # . 直接表示call方法

add[1,2]

# => 3

# Symbol#to_proc

["ruby", "elixir"].map &:capitalize

# => ["Ruby", "Elixir"]

class Symbol
  def to_proc
    -> obj { obj.send(self) }
  end
end

class Person < Struct.new(:name)
  def self.to_proc
    -> person { person.name}
  end
end

[Person.new("Jack"), Person.new("Rick")].map &Person

class ColorFilter < Struct.new(:color)
  def to_proc
    -> item { item.color == self.color}
  end

  def call(list)
    list.select &self
  end
end

filter = -> f, list {
  list.select &f
}

even = -> x { x % 2 == 0 }

filter.(even, (1..10))
# => [2, 4, 6, 8, 10]

map = -> f, list {
  list.map &f
}

double = -> x { x * 2 }

map.(double, (1..5))
# [2, 4, 6, 8, 10]

fold = -> f, init, list {
  list.reduce(init) {|a, b| f.(a, b) }
}

plus = -> x, y { x + y }

fold.(plus, 0, (1..5))

food = -> item { item.category == :food }
price = -> item { item.prece }

fold(plus, 0, map(price, filter(food, items)))

# compose operator
class Proc
  def *(other)
    -> (*args) { self.(other.(*args))}
  end
end

even = -> x { x % 2 == 0}
square = -> x { x * x}
add1 = -> x { x + 1}

# is (x+1)^2 even?
f = even.*square.*add1

f[1]
f[2]


make_adder = -> x {
  -> y { x + y }
}

add1 = make_adder[1]
add2 = make_adder[2]

add1[3] #=> 1 + 3
add2[3] #=> 2 + 3

add = -> x, y, z { x + y + z }

a = add.curry[1]

a[2, 3] #=> 6
a[2][3] #=> 6

add.curry[1,2][3] # => 6
add.curry[1][2][3] # => 6

make_counter = -> amount {
  count = 0    # 在第一次的时候执行一次，之后count的值就是每次迭代的值
  -> { count += amount }
}

a = make_counter.(1)
a.() # => 2
a.() # => 3

b = make_counter.(5)
b.() # => 5
a.() # => 3

class Counter
  attr_reader :count

  def initialize(count: 0)
    @count = count
  end

  def inc
    @count += 1
    self
  end
end

fact = -> n {
  n == 0 ? 1 : n * fact.(n - 1)
}

fact[0] # => 1
fact[1] # => 1 = 1 * fact[0] = 1 * 1
fact[2] # => 2 = 2 * fact[1] = 2 * 1
fact[3] # => 6 = 3 * fact[2] = 3 * 2

class Counter
  attr_reader :count

  def initialize(count: 0)
    @count = count
  end

  def inc
    self.class.new(count: count + 1)
  end
end

fib = -> n {
  if n == 0 || n == 1
    n
  else
    fib.(n-1) + fib.(n-2)
  end
}

(1..10).map &fib

fib = -> (n, memo = {}) {
  if n == 0 || n == 1
    n
  else
    memo[n] ||= fib.(n-1) + fib.(n-2)  # 递归
  end
}

(1..10).map &fib

