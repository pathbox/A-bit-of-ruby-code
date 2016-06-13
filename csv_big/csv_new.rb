require_relative './print_helper'
require 'csv'

print_memory_usage do
  print_time_spent do
    content = File.read('data.csv')
    csv = CSV.new(content, headers: true)
    sum = 0

    while row = csv.shift
      sum += row['id'].to_i
    end

    puts "Sum: #{sum}"
  end
end

# ruby csv_new.rb
# Sum: 500000500000
# Time: 15.3
# Memory: 75.82 MB
