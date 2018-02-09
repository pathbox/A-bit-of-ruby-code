# 全排列算法
def permu(ary, b, e)
  if b >= e
    p ary
  else
    i = b
    (b..e).each do |num|
      t = ary[num]
      ary[num] = ary[i]
      ary[i] = t
      permu(ary, b+1, e)
      t = ary[num]
      ary[num] = ary[i]
      ary[i] = t
    end
  end
end