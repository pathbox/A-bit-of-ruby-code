# gem colorized
#encoding: utf-8
require 'colorize'

puts "蓝色文字".colorize(:blue)
puts "浅蓝色文字".colorize(:light_blue)
puts "还是蓝色文字".colorize(:color => :blue)
puts "浅蓝色文字红色背景".colorize(:color => :light_blue, :background => :red)
puts "浅蓝色文字红色背景第二种写法".colorize(:light_blue).colorize(:background => :red)
puts "浅蓝色文字红色背景第三种写法".light_blue.on_red
puts "蓝色文字红色背景带下划线".blue.on_red.underline

puts "所有颜色-"
puts String.colors

puts "所有效果-"
puts String.modes

puts "显示颜色矩阵"
puts String.color_matrix

puts String.color_matrix("FOO")