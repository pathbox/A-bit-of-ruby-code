require 'wrapper'
require 'csv'

measure do
	CSV.read("/Users/path/tang_poetry.sql")
end

#{"2.2.3":{"gc":"enabled","time":0.39,"gc_count":10,"memory":"44 MB"}}