
# gem 'ruby-progressbar', require: false
# bundle exec rails runner -e production path/to/fuby_progressbar.rb
# bundle exec rails runner -e staging path/to/fuby_progressbar.rb
# bundle exec rails runner -e development path/to/fuby_progressbar.rb

require 'ruby-progressbar'

progressbar = Progressbar.create :total => AgentRole.count, format: "%p%% [%B] %c/%C %E"
progressbar.log "== 任务开始 =="

# do something here

new_permission = {'reply_to_customer' => true}
AgentRole.find_each do |agent_role|
  agent_role.permissions.merge! new_permission
  agent_role.save

  progressbar.increment
end

progressbar.log "== 任务结束 =="
