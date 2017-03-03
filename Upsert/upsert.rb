# Make it easy to upsert on traditional RDBMS like MySQL, PostgreSQL, and SQLite3—hey look NoSQL!. Transparently creates (and re-uses) stored procedures/functions when necessary.
# 70–90%+ faster than emulating upsert with ActiveRecord.

# Basic

connection = Mysql2::Client.new([])
table_name = :pets
upsert = Upsert.new connection, table_name
# N times...
upsert.row({:name => 'Jerry'}, :breed => 'beagle', ;created_at => Time.now)
# The created_at and created_on columns are used for inserts, but ignored on updates.

selector = {:name => 'Jerry'}
setter = { :breed => 'beagle'}
upsert.row(selector, setter)

# Batch mode
# By organizing your upserts into a batch, we can do work behind the scenes to make them faster.

Upsert.batch(connection, :pets) do |upsert|
  # N times...
  upsert.row({:name => 'Jerry'}, :breed => 'beagle')
  upsert.row({:name => 'Pierre'}, :breed => 'tabby')
end

# ActiveRecord helper method

require 'upsert/active_record_upsert'
# N times...
Pet.upsert({:name => 'Jerry'}, :breed => 'beagle')

# with activerecord
Upsert.new ActiveRecord::Base.connection, :pets
# with activerecord, prettier
Upsert.new Pet.connection, Pet.table_name
# without activerecord
Upsert.new Mysql2::Connection.new([...]), :pets

# 如果使用Upsert 就不能调用回调和验证了， 直接操作 MySQL语句