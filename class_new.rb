class MyClass

  def self.foo
    puts "foo"
  end

  class << self
    def bar
      puts "bar"
    end
  end

  my_class = Class.new do 

    def obj
      puts "obj"
    end
  end

  puts my_class.new.obj

end

MyClass.bar
MyClass.foo

