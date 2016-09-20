def select_even_number(array)
  array.select{|i| i.even? }
end

def inject_even_number(array)
  array.map{|i| i if i.even?}.compact
end
