# 令牌算法有点复杂，桶里存放着令牌token。桶一开始是空的，token以固定的速率r往桶里面填充，直到达到桶的容量，多余的token会
# 被丢弃。每当一个请求过来时，就会尝试着移除一个token，如果没有token，请求无法通过
def rate_token(time, capacity, rate, tokens)
  now = Time.now.to_i
  tokens = min(capacity, tokens + (now - time) * rate)
  time = now
  if tokens < 1
    #若不到1个令牌，则拒绝
    return false
  else
    tokens -= 1
    return true
  end
end

# 限制的原理就是 填充的速度和 -1 的速度的比较，当-1 速度大于填充速度，使得tokens < 1的时候，就产生限制
