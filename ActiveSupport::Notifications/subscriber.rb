# Subscriber 可以订阅事件，并将代码块当做参数，传递给 ActiveSupport::Notifications::Event 的实例
module Subscriber
  def self.subscribe(event_nmame)
    ActiveSupport::Notifications.subscribe(evant_name) do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      yield (event)
    end
  end
end

Subscriber.subscribe('user.created') do |event|
  error = "Error: #{event.payload[:exception].first}" if event.payload[:exception]
  puts "#{event.transaction_id} | #{event.name} | #{event.time} | #{event.duration} | #{event.payload[:user].id} | #{error}"
end
