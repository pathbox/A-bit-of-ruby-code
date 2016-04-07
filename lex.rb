require 'ripper'
require 'pp'

code = <<STR
def puts_array
  array = []
  10.times do |n|
    array << n if n < 5
  end
  p array
end
STR

puts code
pp Ripper.lex(code)