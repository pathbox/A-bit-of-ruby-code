arr = [1, 1, 2, 3, 5, 6, 8]

arr.count(&:even?) # => 3
arr.count(1) # => 2
arr.count # => 7
