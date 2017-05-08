def log_a(name)
  log = {title: "title"}
  yield log # 将ｌｏｇ传到外部的block中
  log[:name] = name
  log
end


log_a("Cary") do |log|
  puts log　# 从方法中　接收log
  log[:age] = 22
  log[:city] = "Beijin"
  puts log
end

log_a("Cary") do |txt|
  puts txt　　# 从方法中接收log
  txt[:age] = 22
  txt[:city] = "Beijin"
  puts txt
end