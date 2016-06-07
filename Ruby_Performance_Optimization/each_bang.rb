class Thing; end

list = Array.new(1000) { Thing.new }
puts ObjectSpace.each_object(Thing).count # 1000 objects

list.each do |item|
	GC.start
	puts ObjectSpace.each_object(Thing).count # 1000 objects
end

list = nil
GC.start
puts ObjectSpace.each_object(Thing).count # 1000 objects

# 1000
# 1000
# «...»
# 1000 1000 1

# Obviously we can’t deallocate list before each finishes. 
# So it will stay in memory even if we no longer need access to previously traversed items. 
# Let’s prove that by counting the number of Thing instances before each iteration.