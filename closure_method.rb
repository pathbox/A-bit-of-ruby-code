def my_method
  x = "Goodbye"
  yield("cruel") if block_given?
end

x = "Hello"
my_method { |y| p "#{x}, #{y} world" }

