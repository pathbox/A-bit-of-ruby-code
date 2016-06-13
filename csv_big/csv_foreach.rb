require_relative './print_helper'
require 'csv'

print_memory_usage do
  print_time_spent do
    sum = 0

    CSV.foreach('data.csv', headers: true) do |row|
      sum += row['id'].to_i
    end

    puts "Sum: #{sum}"
  end
end

# ruby csv_foreach.rb
# Sum: 500000500000
# Time: 13.63
# Memory: 1.8 MB
