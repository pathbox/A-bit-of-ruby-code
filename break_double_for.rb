 #encoding:utf-8
catch :for_loop do
  loop do
    a = 1
    puts "here"
    while a < 100
      a += 1
      if a > 10
      puts a
        throw :for_loop  # break can't go to the double outside
      end
    end
  end
end
puts "outside"