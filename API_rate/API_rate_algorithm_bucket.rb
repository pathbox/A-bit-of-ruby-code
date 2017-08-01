# 首先，我们有一个固定容量的桶，有水进来，也有水出去。对于流进来的水，我们无法预计共有多少水流进来，也无法预计流水速度，但
# 对于流出去的水来说，这个桶可以固定水流的速率，而且当桶满的时候，多余的水会溢出来
def rate_bucket(time, rate, water, capacity)
  # time = Time.now.to_i
  # rate = 0      #水漏出的速度
  # water = 0     #当前水量(当前累积请求数)
  # capacity = 0  #桶的容量
  now = Time.now.to_i
  water = max(0, water - (now - time) * rate) # 先执行漏水，计算剩余水量
  time = now
  if (water+1) < capacity
    # 水没满，加水
    water += 1
    return true
  else
    return false  # 水满了,拒绝加水
  end
end