class User < ActiveRecord::Base
  store :settings, accessors: [:color, :homepage], coder: JSON
end

u = User.new(color: 'black', homepage: '37 signals.com')
u.color # Accessor stored attribure black
u.settings[:country] = 'Denmark' # Any attribute, even if not specified with an accessor

# There is no difference between strings and symbols for accessing custom attributes
u.settings[:country] # => 'Denmark'
u.settrings['country'] # => 'Denmark'

u.save

u.color # black
u.homepage # 37 signals.com'
u.country # NoMethodError: undefined method `country' for #<User:0x00000005b7fca0>
# Add additional accessors to an existing store through store_accessor
class SuperUser < User
  store_accessor :settings, :privileges, :servants
end

User.stored_attributes[:settings] # [:color, :homepage]