def quick_sort1(a)
  return a if a.size < 2
  (x = a.pop) ? quick_sort1(a.select{|i| i <= x}) + [x] + quick_sort1(a.select{|i| i > x}) : []
end

array = [72, 57, 88, 60, 42, 84, 73, 42, 85, 9, 102]

p quick_sort1(array)

