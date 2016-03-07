# different quick sort

def quick_sort1(a)
  return a if a.size < 2
  (x = a.pop) ? quick_sort1(a.select{|i| i <= x}) + [x] + quick_sort1(a.select{|i| i > x}) : []
end

def quick_sort2(a)
  return a if a.size < 2
  left, right = a[1..-1].partition{ |y| y <= a.first }  # 以第一个元素为第一次的比较元素x
  sort(left) + [ a.first ] + sort(right)  # 左边部分继续递归排序, 右边部分继续递归排序。直到 a.size < 2.即直到a.size 为 1
end


array = [72, 57, 88, 60, 42, 84, 73, 42, 85, 9, 102]

p quick_sort1(array)

