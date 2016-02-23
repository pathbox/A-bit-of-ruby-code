# Proc#call vs yield

def slow(&block)
  block.call
end

def fast
  yield
end
# 原因： 第一种写法要不断的创建Proc对象赋给block参数导致慢

# Enumerable#map and Array#flatten versus Enumerable#flat_map

def slow
  (1..50).map{|i| i.divmod(7)}.flatten
end

def fast
  (1..50).flat_map{|i| i.divmod(7)}
end

# Hash#merge versus Hash#merge! (bang methods, in general)

def slow
  (1..10).inject({}){|h, e| h.merge(e => e)}
end

def fast
  (1..10).inject({}){|h, e| h.merge!(e => e)}
end

# Hash#merge! versus Hash#[]=

def slow
  {:foo => :bar}.fetch(:foo, (1..10).to_a)
end

def fast
  {:foo => :bar}.fetch(:foo){ (1..10).to_a}
end

# String#gsub versus String#sub  vs String#tr

def slow
  'http://parley.rubyrogues.com/'.gsub(%r{\Ahttp://}, 'https://')
end

def fast
  'http://parley.rubyrogues.com/'.sub(%r{\Ahttp://}, 'https://')
end

def very_fast
  'http://parley.rubyrogues.com/'.tr(%r{\Ahttp://}, 'https://')
end

# Parallel versus sequential assignment

def slow
  a, b = 1,2
end

def fast
  a = 1
  b = 2
end


# Explicit versus implicit String concatenation

def very_slow
  "foo" + "bar"
end

def slow
  "foo" << "bar"
end

def fast
  "foo" "bar"
end

# Using exceptions for control flow

def slow
  self.no_method
rescue NoMethodError
  "doh!"
end

def fast
  respond_to?(:no_method) ? self.no_method : "doh!"
end

# while loops versus each_with_index

ARRAY = [1, 2, 3, 1, '2', 4, '5', 6, 7, 8, 9,'10']

def slow
  hash = {}

  ARRAY.each_with_index do |item, index|
    hash[index] = item
  end

  hash
end

def fast
  hash = {}
  index = 0
  length = ARRAY.length

  while index < length
    hash[index] = ARRAY[index]
    index += 1
  end

  hash
end







































