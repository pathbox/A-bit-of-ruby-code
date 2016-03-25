input = File.open(ARGV[0], 'r')

dic = Hash.new(0)

while line = input.gets
  words = line.scan /\p{Letter}+'*\p{Letter}*/
  words.each { |w| dic[w.downcase] += 1 unless w.empty? }
end

dic.sort_by { |_, value| - value }.each{ |entry| puts "#{entry[0]}: #{entry[1]}\n" }

# class Array
#   def word_count
#     frequencies = Hash.new(0)
#     each do |word|
#       frequencies[word] += 1
#     end
#     return frequencies
#   end
# end

# a = %w{hello world ! !}
# p a.word_count
#
# p [1,1,2,3,"4",4].word_count