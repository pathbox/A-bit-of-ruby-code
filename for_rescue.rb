# begin
#   # Raise an error here
#   raise "Error!!"
# rescue
#   #handle the error here
# ensure
#   p "=========inside ensure block"
# end

# 1. 异常保存到变量
begin
  ary = [1,nil,2,3,4]
  ary.each do |i|
    puts i - 1
  end
rescue => e  #异常保存到变量
  puts e
end

# 2. 用rescue捕获异常
#
begin
  ary = [1,nil,2,3,4]
  ary.each do |i|
    puts i - 1
  end
rescue NoMethodError
  puts "Method Error"
end

# 3. raise抛出异常

begin
  ary = [1,nil,2,3,4]
  ary.each do |i|
    raise "The i is nil" if i.nil?
    puts i - 1
  end
rescue ArgumentError
  puts "ArgumentError"
end

#4 创建异常类

class ThrowExceptionLove < Exception
  puts "Some Error"
end

begin
  raise ThrowExceptionLove, "Got Error"
rescue ThrowExceptionLove => e
  puts "Error: #{e}"
end