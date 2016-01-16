some_words = "Single page web is ok and nice if is ok hello world"

result = {}
some_words.split(" ").each do |word|
  result[word] ||= 0
  result[word] +=1
end

p result

result = Hash.new(0)
h = Hash.new(0)

some_words.split(" ").map{|word| result[word] += 1}

p result
p h

result = Hash.new{|hash,key| hash[key]=[]}

# the word's index in the sentence
some_words.split(" ").each_with_index{|word, index| result[word] << index }

p "======================"
p result
p "======================"
