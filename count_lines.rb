# count the lines in a file from a dir
def count_lines
  lines = 0
  fo = 0
  files = Dir["./*"]
  files.map do |file|
    f = File.open("#{file}", "r", encoding:"utf-8")
    f.each_line{lines += 1}
    File.foreach("#{file}") {fo += 1}
    o = IO.readlines("#{file}", encoding:"utf-8") # 每个文件变成一个数组,每一行变成数组的一个元素
  end
  p fo
  lines
end

p "这个文件夹有#{count_lines}行代码."

# *** In ruby, file.readlines.each not faster than file.open.each_line, why?

# Both readlines and open.each_line read the file only once. And Ruby will do buffering on IO objects,
# so it will read a block (e.g. 64KB) data from disk every time to minimize the cost on disk read.
# There should be little time consuming difference in the disk read step.
# When you call readlines, Ruby constructs an empty array [] and repeatedly reads a line of file contents and pushes it to the array.
# And at last it will return the array containing all lines of the file.
# When you call each_line, Ruby reads a line of file contents and yield it to your logic.
# When you finished processing this line, ruby reads another line. It repeatedly reads lines until there is no more contents in the file.
# The difference between the two method is that readlines have to append the lines to an array. When the file is large, Ruby might have to duplicate the underlying array (C level) to enlarge its size one or more times.
# Digging into the source, readlines is implemented by io_s_readlines which calls rb_io_readlines. rb_io_readlines calls rb_io_getline_1 to fetch line and rb_ary_push to push result into the returning array.
# each_line is implemented by rb_io_each_line which calls rb_io_getline_1 to fetch line just like readlines and yield the line to your logic with rb_yield.
#So, there is no need to store line results in a growing array for each_line, no array resizing, copying issue.

# *** don't use read, because it read the whole file, it's better to use open or foreach