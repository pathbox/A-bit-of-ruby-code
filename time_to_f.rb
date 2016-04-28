puts "精确到秒时间"
puts Time.now.strftime("%Y%m%d%H%M%S")
puts "精确到毫秒时间"
puts Time.now.strftime("%Y%m%d%H%M%S%L")
puts "精确到秒时间戳"
puts Time.now.to_i
puts "精确到纳秒时间戳"
puts Time.now.to_f