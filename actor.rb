require 'celluloid'

class Universe
  include Celluloid

  def say(msg)
    puts msg
    Celluloid::Actor[:world].say("#{msg} World!")
  end
end

class World
  include Celluloid

  def say(msg)
    puts msg
  end
end

Celluloid::Actor[:world] = World.new
Universe.new.say("Hello")