# 同时向几十上百台Linux服务器上传文件并执行命令，如果一个个来，那你就真是挨踢民工。程序员要发挥自己懒惰的个性，借用Net::SSH和net::SCP用Ruby写个脚本你会发现非常简单

require 'net/ssh'
require 'net/scp'

HOST = '192.168.1.1'
USER = 'username'
PASS = 'password'

Net::SSH.start(HOST, USER, :password => PASS) do |ssh|
  result = ssh.exec!('ls')
  puts result
end

# Net::SSH.start会与目标主机建立一个连接，并返回一个代表连接的session。如果后面接收一个block，会在block结束时自动关闭连接。
# 否则要自己关闭连接。注意密码作为一个hash参数传递，是因为SSH登录验证方式比较多，需要的参数变化多样

# 如果即要传输文件，又要执行命令，scp不必重新建立连接，借用ssh连接即可
Net::SSH.start( HOST, USER, :password => PASS) do |ssh|
  logfiles = ssh.exec!('ls *.log').split
  logfiles.each do |log|
    ssh.scp.download!(log, log)
  end
end

# 如果要传输大文件，最好能显示传输进度，不然好久没反应，还会以为死机了呢

Net::SSH.start(HOST, USER, :pasword => PASS) do |ssh|
  ssh.scp.upload!('large.zip', '.') do |ch, name, sent, total|
    print "\r#{name}: #{(sent.to_f * 100 / total.to_f).to_i}"
  end
end

# 上传一个目录，包括子目录中的所有文件。加上“:recursive => true”参数

Net::SSH.start(HOST, USER, :password => PASS) do |ssh|
  ssh.scp.upload!("logs", ".", :recursive => true)
end

# 如果下载后不想保存成文件，而是放到内存中直接处理，只要不给download!传递本地文件名即可，会返回一个字符串

Net::SSH.start(HOST, USER, :pasword => PASS) do |scp|
  puts scp.download!('log.txt').split(/\n/).grep(/^ERROR/)
end

# scp最高级应用，根据事件显示所有传输信息。

Net::SCP.start(HOST, USER, :password => PASS) do |scp|
  sftp.upload!(f, remote_file) do |event, uploader, *args|
    case event
      # args[0] : file metadata
      # args[1] : byte offset in remote file
      # args[2] : byte data being written (as string)
      when :open
        puts "start uploading.#{args[0].local} -> #{args[0].remote} #{args[0].size} bytes"
      when :put then
        puts "writing #{args[2].length} bytes to #{args[0].remote} starting at #{args[1]}"
      when :close then
        puts "finished with #{args[0].remote}"
      when :mkdir then
        puts "creating directory #{args[0]}"
      when :finish
        puts "all done!"
    end
  end

  puts "upload success"
end




























