require 'csv' 
require 'wrapper'
measure do
file = CSV.open("/Users/path/tang_poetry.sql", 'r') 
	while 
		line = file.readline 
	end
end


# ruby -I . file_reading5.rb --no-gc
# {"2.2.3":{"gc":"disabled","time":0.39,"gc_count":0,"memory":"72 MB"}}


# ruby -I . file_reading5.rb
# {"2.2.3":{"gc":"enabled","time":0.38,"gc_count":13,"memory":"22 MB"}}