require_relative './print_helper'
require 'csv'

print_memory_usage do
  print_time_spent do
    File.open('data.csv', 'r') do |file|
      csv = CSV.new(file, headers: true)
      sum = 0

      while row = csv.shift
        sum += row['id'].to_i
      end

      puts "Sum: #{sum}"
    end
  end
end


# ruby csv_new_file_open.rb 
# Sum: 500000500000
# Time: 14.59
# Memory: 1.73 MB
