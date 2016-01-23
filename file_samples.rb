#file = File.new("../temp/one.txt","w")
#file = File.new("../temp/two.txt",0777,File::CREAT)
#File.open("../temp/one.txt","w") do |file|
#  file.puts "Line 1"
#  file.puts "Line 2"
#end
# The file is now closed

#File.open("file1","r+") do |f|
#  f.puts "hello file1"
#end
#read/write starting at beginning of file
File.open("../temp/file2","w+") do |f|
  f.puts "hello file2"
end
#read/write truncate existing file or create a new one
File.open("../temp/file3","a+") do |f|
  f.puts "hello file3"
end
#read/write start at end of existing file or create a new one
