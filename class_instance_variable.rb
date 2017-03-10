class Person
  attr_accessor :city  # class instance instance variable
  @name = "John"  # class instance variable

  def p_name
    puts "instance name: #{@name}"
    @age = 20 # instance method instance variable
    puts "instance age: #{@age}"
    puts "instance city: #{self.city}" # class instance instance variable
  end

  def self.p_name
    puts "class name: #{@name}" # class instance variable
    puts "class age: #{@age}"
  end
  puts "class name: #{@name}"
  puts "class age: #{@age}"
  puts "class new city: #{self.new.city}"
end
Person.p_name
person = Person.new
person.city ="Beijing"
person.p_name