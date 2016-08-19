require 'redis'

class Subscriber
  def subscribe(channel)
    Redis.current.subscribe(channel) do |on|
      on.subscribe do |channel, _|
        puts "subscribed to #{channel}"
      end

      on.message do |channel, message|
        puts "#{channel} received #{message}"
      end
    end
  end
end
