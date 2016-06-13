require_relative './print_helper'
require 'csv'

print_memory_usage do
  print_time_spent do
    content = File.read('data.csv')
    csv = CSV.parse(content, headers: true)
    sum = 0

    csv.each do |row|
      sum += row['id'].to_i
    end

    puts "Sum: #{sum}"
  end
end

# ruby csv_parse.rb
# Sum: 500000500000
# Time: 20.03
# Memory: 1217.13 MB
