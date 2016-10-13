module Publisher
  extend self

  def broadcast_event(event_name, payload = {})
    if block_given?
      ActiveSupport::Notifications.instrument(event_name, payload)do
        yield
      end
    else
      ActiveSupport::Notifications.instrument(event_name, payload)
    end
  end
end

# 我们可以在 model 或 controller 中发布具体事件。

if user.save
  # publish event 'user.created', with payload {user: user}
  Publisher.broadcast_event('user.created', user: user)
end

def create_user(params)
  user = User.new(params)
  # publish event 'user.created', with payload {user: user}, using block syntax
  # now the event will have additional data about duration and exceptions
  Publisher.broadcast_event('user.created', user: user) do
    User.save!
    # do some more important stuff here
  end
end
