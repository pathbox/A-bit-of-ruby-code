# https://github.com/ohler55/oj
# http://www.ohler.com/dev/oj_misc/performance_strict.html
require 'oj'

h = {'one' => 1, 'array' => [true, false]}
json = Oj.dump(h)
h1 = {one: 1, array: [true, false]}
json1 = Oj.dump(h1)
puts json1
puts json

h2 = Oj.load(json)
puts "Same? #{h == h2}"

h3 = Oj.load(json1)
puts h3
puts "Same1? #{h3 == h1}"
