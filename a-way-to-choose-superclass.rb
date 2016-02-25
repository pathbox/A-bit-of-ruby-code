
class Shape
end

circle_is_shape = true
  class Circle < (circle_is_shape ? Shape : Object) # here is amazing!
end

p Circle.superclass # -> Shape