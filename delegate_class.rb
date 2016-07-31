require 'delegate'

class Assistant
  def initialize(name)
    @name = name
  end

  def read_email
    p "(#{@name}) It is mostly spam."
  end

  def check_schedule
    p "(#{@name}) You have a meeting today."
  end
end

class Manger < DelegateClass(Assistant)
  def initialize(assistant)
    super(assistant)
  end

  def attend_meeting
   p "Please hold my calls."
  end
end

frank = Assistant.new("Frank")
anne = Manger.new(frank)
anne.attend_meeting
anne.read_email
anne.check_schedule