User.find_or_create_by(id: 1, age: 22) do |user|
  user.name = "John"
  user.city = "Beijing"
end
