task :lover do
  puts "find the love !"
end
task :valentines_day => :lover do
  puts "Today is Valentines Day !"
end

desc "show good test !"
task :notes => :environment do
  Pub::StafferNoticeIds.find_each.each do |u|
	puts u.id
	break if u.id > 11111
  end
end
# namespace 可以把我们的rake任务分组，这样可以避免一些命名冲突，也可以让我们的rake任务组织得更有条理一些

namespace :food do
  task :my_food => :environment do
	puts "My food is egg"
  end
end
