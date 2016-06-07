require 'wrapper'

measure do
	file = File.open("/Users/path/tang_poetry.sql", 'r')
	while line = file.gets
		line.split(",")
	end
end

# ruby -I . file_reading4.rb --no-gc

# {"2.2.3":{"gc":"disabled","time":0.1,"gc_count":0,"memory":"40 MB"}}

# ruby -I . file_reading4.rb
# {"2.2.3":{"gc":"enabled","time":0.11,"gc_count":12,"memory":"10 MB"}}