# 循环遍历某个文件夹下的所有文件  用到了递归

def require_all(path)
  Dir.glob("#{path}/*") do |f_path|
    if File.directory?(f_path)
      require_all f_path
    else
      require f_path
    end
  end
end

puts File.join("./", "app")
puts Dir.glob("./*")

require_all File.join("./", "app")
require_all File.join('./', "lib")
