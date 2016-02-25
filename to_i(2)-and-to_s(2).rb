# Given two binary strings, return their sum (also a binary sting)
# For example,
# a = '11'
# b = '1'
# Return '100'.

def add_binary(a,b)
  (a.to_i(2) + b.to_i(2)).to_s(2)
end
