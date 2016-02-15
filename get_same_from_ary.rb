# 取出两个数组的相同元素
#
class GetSame
def self.get_same(a=[],b=[])
  hash = {}
  result = {}
  a.each do |x|
    hash[x]=true
  end
  b.each do |y|
    result[y]=true if hash.has_key?(y)
  end
  return result
end
end

p GetSame.get_same([1,2,3],[3,4,5])

