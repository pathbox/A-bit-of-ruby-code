# 接口限流算法 计数算法, 在interval的时间内，计数加一，检查次数是否超过限制。时间过期了，重置时间和次数
def rate_count(limit, interval)
  time = Time.now.to_i
  req_count = 0
  # limit = 100 #时间窗口内最大请求数
  # interval = 1000  # 时间窗口ms

  now = Time.now.to_i
  if now < time + interval
    req_count++
    return req_count <= limit
  else
    time = now
    req_count = 1
    return true
  end
end