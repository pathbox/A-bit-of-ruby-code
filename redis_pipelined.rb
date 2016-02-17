# redis 的管道 初级代码

# gem install redis-rails or redis or redis-rack-cache

redis = Redis.new #<Redis client v3.2.1 for redis://127.0.0.1:6379/0>

# 管道是用于批量发送指令给redis服务器,当你需要发送很多的指令给redis服务器时,就可以用管道,毕竟每条指令发送到服务器,再服务器返回响应,
# 都是需要时间的,而把所有指令合成一个管道一起发送,这样就能大大的减少时间
redis.pipelined do
  redis.set "foo", "bar"
  redis.incr "baz"
end