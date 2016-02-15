#class Blog < ActiveRecord::Base

#  belongs_to :user

#  delegate :name, :address, :age, to: :user, prefix: true, allow_nil: true

  # @blog.user.name <=> @blog.user_name
  # @blog.user.address <=> @blog.user_address
  # @blog.user.age <=> @blog.user_age

#end

require 'timeout'

begin
  timeout(0.1){
    sleep 0.2
  }
rescue TimeOut::Error => e
  puts e.message
end

i= 3
begin
  xxxx
rescue StandardError => e
  i -=1
  puts e.message
  retry if i > 0
ensure
  puts "I will be execute"
end

i = 3
begin
  xxx
rescue StandardError => e
  i -= 1
  puts e.message
  retry if i > 0
ensure
  puts "I will be execute"
end

lock_version
lock_version
set_locking_column :lock_client_column
set_locking_column :lock_client_column
set_locking_column :lock_client_column
lock_version
customer.orders.size
customer.orders(true).empty?

