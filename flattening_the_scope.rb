var = "Success"

MyClass = Class.new do
  puts "#{var} in the class definition!"

  def my_method
    puts "#{var} in the method."
  end

  define_method :here do
    puts "#{var} is here"
  end
end

MyClass.new.here
MyClass.new.my_method  # undefined local variable or method 'var'
