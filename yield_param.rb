def log_a(name)
  log = {title: "title"}
  yield log
  log[:name] = name
  log
end


log_a("Cary") do |log|
  puts log
  log[:age] = 22
  log[:city] = "Beijin"
  puts log
end

log_a("Cary") do |txt|
  puts txt
  txt[:age] = 22
  txt[:city] = "Beijin"
  puts txt
end