# gem install net-ssh
# gem install net-scp

# encoding: utf-8

require 'net/ssh'
host = '192.168.100.xx'
username = username
password = pwd

server_cmd_1 = 'ls -l'
server_cmd_2 = 'cat /etc/issue'

# 连接到远处主机

ssh = Net::SSH.start(host, username, :password => password) do |ssh|
  result = ssh.exec!(server_cmd_1)
  puts result result = ssh.exec!(server_cmd_2)
  puts result
end

