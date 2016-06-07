module Logger
	extend self
	attr_accessor :output, :log_actions

	def log(&event)
		self.log_actions ||= []
		self.log_actions << event
	end

	def play
		output = []
		log_actions.each { |e| e.call(output) }
		puts output.join("\n")
	end
end

class Thing
	def initialize(id)
		Logger.log{ |output| output << "created thing #{id}" }
	end
end

def do_something
	1000.times { |i| Thing.new(i) }
end

do_something
GC.start     # => collect all unused objects
Logger.play
puts ObjectSpace.each_object(Thing).count

# After we’re done with the do_something, we don’t really need all one thousand of these Thing objects.
#  But even an explicit GC.start call does not collect them. What’s going on?
# Callbacks stored in the Logger class are the reason the objects are still there. 
# When you pass an anonymous block in the Thing constructor to the Logger
#  #log function, Ruby converts it into the Proc object and stores references to all objects in the block’s 
#  execution context. That includes the Thing instance. In this way we end up keeping references from the Logger object to all 
# one thou- sand instances of Thing. It’s a classic example of a memory leak.