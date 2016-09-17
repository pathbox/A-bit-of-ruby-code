User < ActiveRecord::Base
  store :profile, accessors: [:age, :birthday, :hobby, :nickname, :like], coder: JSON
  store :settings, accessors: [:color, :homepage], coder: JSON
  serialize :phone, Array
  serialize :school, Hash
end

user = User.new(color: 'blue', homepage: '37signals.com')

user.color # Accessor stored attribute
user.settings[:country] = 'Denmark' # Any attribute, even if not specified with an accessor
# There is no difference between strings and symbols for accessing custom attributes
u.settings[:country]  # => 'Denmark'
u.settings['country'] # => 'Denmark'  # 不一定要在accessors中定义的字段才可以使用, settings是一个json, 可以临时增加key

# Add additional accessors to an existing store through store_accessor
class SuperUser < User
  store_accessor :settings, :privileges, :servants
end

# The stored attribute names can be retrieved using .stored_attributes.

User.stored_attributes[:settings] # [:color, :homepage]

# Overwriting default accessors

# All stored values are automatically available through accessors on the Active Record object, but sometimes you want to specialize this behavior. This can be done by overwriting the default accessors
# (using the same name as the attribute) and calling super to actually change things.

class Song < ActiveRecord::Base
  store :settings, accessors: [:volume_adjustment]

  def volume_adjustment = (decibels)
    super(decibels.to_i)
  end

  def volume_adjustment
    super.to_i
  end
end
