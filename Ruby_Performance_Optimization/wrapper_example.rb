require 'wrapper'
require 'csv'

measure do

	data = CSV.open("data.csv")
	output = data.readlines.map do |line|
		line.map{ |col| col.downcase.gsub(/\b('?[a-z])/) { $1.capitalize } }
	end

	File.open("output.csv", "w+") { |f| f.write output.join("\n") }
end


# $ ruby -I . wrapper_example.rb
# {"2.2.0":{"gc":"enabled","time":14.96,"gc_count":27,"memory":"479 MB"}}
# $ ruby -I . wrapper_example.rb --no-gc
# {"2.2.0":{"gc":"disabled","time":10.17,"gc_count":0,"memory":"1555 MB"}}