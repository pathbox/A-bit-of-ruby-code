def colorize(str, color_code = 31)
  "\e[#{color_code}m#{str}\e[0m"
end

def blue(str, color_code = 34)
  colorize(str, color_code)
end

def red(str, color_code = 31)
  colorize(str, color_code)
end

puts blue("我是蓝色")
puts red("我是红色")