require 'file'


path = "/home/user/download/email.eml"

file = File.open(path)

file # <File:/home/user/download/email.eml>

file.class # File

file.each do |f|
  puts f
end

# 逐行输出出文件的内容
file.each do |f|
  puts f
end

# nothing

# 当file是文件是，文件只会被读取一次，读取完就没了，下一次在each输出的时候就没有数据


file = File.open(path).read  # File.read(path)

file # a large string
file.class # String

puts file # a large string