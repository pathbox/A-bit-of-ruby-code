require 'active_support/lazy_load_hooks'

class Say
  def initialize(name)
    @name = name
    ActiveSupport.run_load_hooks(:instance_of_color, self)
  end
end

ActiveSupport.on_load :instance_of_color do
  puts "Hi #{@name}"
end

Say.new("kelby")