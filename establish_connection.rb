# 通过 establish_connection 连接数据库，我们不必加载整个 Rails 环境，仅使用数据库操作这部分

require 'yaml'
require 'active_record'

dbconfig = YAML::load(File.open('config/database/yml'))

ActiveRecord::Base.establish_connection(dbconfig["development"])
ActiveRecord::Base.logger = Logger.new(STDERR)

class User < ActiveRecord::Base
  #......
end
