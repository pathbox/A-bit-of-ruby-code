require 'wrapper'

measure do
	class Thing; end
	list = Array.new(1000) { Thing.new } # allocate 1000 objects again 
	puts ObjectSpace.each_object(Thing).count

	while list.count > 0
		GC.start
		puts ObjectSpace.each_object(Thing).count
		item = list.shift
		puts item
	end

	GC.start
	puts ObjectSpace.each_object(Thing).count
end