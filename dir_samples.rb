Dir.foreach("../temp") do |entry|
  puts entry
end
d = Dir.foreach("../temp")
de = Dir.entries("../temp")
puts "==============="
puts d.class #Enumerator
puts de.class # Array
