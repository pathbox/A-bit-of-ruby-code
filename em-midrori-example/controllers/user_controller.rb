class UserController
	class << self
		def login(username, password)
			raise ForbiddenRequest unless username.is?String
			raise ForbiddenRequest unless password.is?String
      user = await User.find({username: username})
      raise UnauthorizedError if user.nil?
      raise UnauthorizedError unless user.password == password
      user.token = SecureRandom.uuid
      await user.save!
      {code: 0, token: user.token}
		end

		def get_profile(id)
			user = await User.find(id)
			raise NotFoundRecord unless user
			{username: user.name, avatar: user.avatar_url}
		end
	end
end