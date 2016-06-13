require_relative './print_helper'
require 'csv'

print_memory_usage do
	print_time_spent do
		csv = CSV.read('data.csv', headers: true)
		sum = 0
		csv.each do |row|
			sum += row['id'].to_i
		end

		puts "Sum: #{sum}"
	end
end

# ruby csv_read.rb
# Sum: 500000500000
# Time: 21.27
# Memory: 1158.29 MB