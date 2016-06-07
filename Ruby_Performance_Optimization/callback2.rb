module Logger
extend self
attr_accessor :output
	def log(&event)
		self.output ||= []
		event.call(output)
	end
	def play
		puts output.join("\n")
	end
end

class Thing
	def initialize(id)
		Logger.log { |output| output << "created thing #{id}" }
	end
end
	def do_something
		1000.times { |i| Thing.new(i) }
	end
do_something
GC.start
Logger.play
puts ObjectSpace.each_object(Thing).count

# So be careful every time you create a block or Proc callback. Remember, 
# if you store it somewhere, you will also keep references to its execution context.
#  That not only hurts the performance, but also might even leak memory