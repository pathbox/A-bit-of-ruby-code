def test(arg=nil)
  begin  # outter begin
    if arg == 1
      10.times.each do |i|
      begin   # inner begin
        if i == 2
          raise "here is 2"
        else
          puts i
        end
      rescue => e
        puts e
      end
    end
  elsif arg == 2
    10.times.each do |i|
      if i == 2
        raise "here is 2"
      else
        puts i
      end
    end
  else
    10.times.each do |i|
      if i == 2
        raise "here is 2"
      else
        puts i
      end
    end
  end
  rescue => e
    puts e
  end
end

# inner begin 捕捉异常,且不会中断循环
# outter begin 捕捉异常,但是会中断循环