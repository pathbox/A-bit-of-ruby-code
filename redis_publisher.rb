uburequire 'redis'

class Publisher
  def publish(channel, message)
    Redis.current.publish(channel, message)
  end
end
