#file = File.new("../temp/one.txt","w")
#file = File.new("../temp/two.txt",0777,File::CREAT)
File.open("../temp/one.txt","w") do |file|
  file.puts "Line 1"
  file.puts "Line 2"
end
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

#file = File.new("../temp/one.txt")
#file.flock(File::LOCK_EX)
#file.flock(File::LOCK_EX | File::LOCK_NB)
#status = File.stat("../temp/one.txt").mode
File.chmod(0766,'../temp/one.txt')
info = File.stat('../temp/one.txt')
info.readable?
info.writable?
info.executable?
flag = File::exists?("../temp/one.txt")
puts flag
#File.delete("../temp/one.txt")
#puts File::dirname("../temp/one.txt")
puts File::join("","home","hello","guy")
puts File::join("home","hello","guy")
truncate_file = File::truncate('../temp/2015.log',1024*1024*8) #截断指定文件为 len字节 原来的文件被覆盖
puts truncate_file.size
# File.rename("../temp/one.txt","../temp/one_bak.txt")
#
#require "fileutils"
FileUtils.copy("../temp/one.txt", "../temp/on_bak.txt",true)
#FileUtils.move("../temp/names","/etc")
