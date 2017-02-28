class Person
  include CheckedAttributes

  attr_checked :age do |v|
    v >= 18
  end
end

me = Person.new

me.age = 29  # Ok
me.age = 12 # Exception