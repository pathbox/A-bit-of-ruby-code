require 'wrapper'
measure do
	File.readlines("/Users/path/tang_poetry.sql").map { |line| line.split(",") }
end

# {"2.2.3":{"gc":"disabled","time":0.1,"gc_count":0,"memory":"40 MB"}}