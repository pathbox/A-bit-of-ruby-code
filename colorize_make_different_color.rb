class String

  def color_black
    "\033[30m#{self}\033[0m"
  end

  def color_red
    "\033[31m#{self}\033[0m"
  end

  def color_green
    "\033[32m#{self}\033[0m"
  end

  def color_brown
    "\033[33m#{self}\033[0m"
  end

  def color_blue
    "\033[34m#{self}\033[0m"
  end

  def color_magenta
    "\033[35m#{self}\033[0m"
  end

  def color_cyan
    "\033[36m#{self}\033[0m"
  end

  def color_gray
    "\033[37m#{self}\033[0m"
  end

  def bg_black
    "\033[40m#{self}\033[0m"
  end

  def bg_red
    "\033[41m#{self}\033[0m"
  end

  def bg_green
    "\033[42m#{self}\033[0m"
  end

  def bg_brown
    "\033[43m#{self}\033[0m"
  end

  def bg_blue
    "\033[44m#{self}\033[0m"
  end

  def bg_magenta
    "\033[45m#{self}\033[0m"
  end

  def bg_cyan
    "\033[46m#{self}\033[0m"
  end

  def bg_gray
    "\033[47m#{self}\033[0m"
  end

  def bold
    "\033[1m#{self}\033[0m"
  end

  def reverse_color
    "\033[7m#{self}\033[0m"
  end
end

puts "I am back green".bg_green

puts "I am red and back cyan".color_red.bg_cyan

puts "I am bold and green and background red".bold.color_green.bg_red

puts "I am blue".color_blue
