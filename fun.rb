def fun1
  i = 0
  while i<=5
	puts "fun1 at: #{Time.now}"
	puts Thread.current
	sleep(2)
	i=i+1
  end
end

def fun2
  j = 0
  while j<=5
	puts "fun2 at: #{Time.now}"
	puts Thread.current
	sleep(1)
	j=j+1
  end
end

puts "Started at #{Time.now}"
puts Thread.current
t1 = Thread.new{fun1()}
t2 = Thread.new{fun2()}
puts Thread.current

t1.join
t2.join
puts "End at #{Time.now}"
