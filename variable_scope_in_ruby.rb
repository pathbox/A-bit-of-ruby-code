class Person
  @age = 20
  def somebody
    p @age
    @age = 22
    p @age
  end
  def self.myself
    p @age
  end
end

person = Person.new
person.somebody
Person.myself
