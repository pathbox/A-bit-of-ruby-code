def fact(n)
  if n == 1
    return 1
  else
    return n * fact(n-1)
  end
end

for i in 1..15
  printf "fact(%d)=%d\n", i, fact(i)
end
