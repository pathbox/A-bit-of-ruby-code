# increment and decrement

@user = User.first

@user.increment(:age) # @user.age + 1
@user.increment(:age, 2) #@user.age + 2
@user.save

#or you can  '@user.increment!(:age)'
