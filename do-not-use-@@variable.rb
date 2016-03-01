#Avoid the usage of class (@@) variables due to their "nasty" behavior in inheritance.
#避免使用类变量（@@）因为他们讨厌的继承习惯（在子类中也可以修改父类的类变量）。
  class Parent
    @@class_var = 'parent'

    def self.print_class_var
      puts @@class_var
    end
  end

  class Child < Parent
    @@class_var = 'child'
  end

  Parent.print_class_var # => will print "child"
#正如上例看到的, 所有的子类共享类变量, 并且可以直接修改类变量,此时使用类实例变量是更好的主意.