ary = (1..100).to_a

File.open('../temp/dump.txt',"w+") do |file|
  Marshal.dump(ary,file)
end

File.open('../temp/dump.txt') do |file|
  info = Marshal.load(file) 
  puts info
  puts info.class
end

