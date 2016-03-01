# good
class Person
  attr_reader :first_name, :last_name

  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
  end
end

# better
class Person < Sturct.new(:first_name, :last_name)
end

# better
Person = Struct.new(:first_name, :last_name) do
end