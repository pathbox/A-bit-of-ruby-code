require 'objspace'

GC.start
File.open("memory.json","w") do |file|
  ObjectSpace.dump_all(output: file)
end