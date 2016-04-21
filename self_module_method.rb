module SelfModuleMethod

  def self.methods_for(*names)
    names.each do |name|
      class_eval %Q{
          def #{name}
            file = File.open("data/#{name}.txt")
            h = {}
            file.each_line do |line|
              name, id = line.split(" ")
              h[name] = id
            end
            h
          end
        }
    end
  end

  methods_for :age, :religion, :city

end

# if User include the module, you can use  User.age, User.religion, User.city methods.
# As the same, you can build User.new.age like modify the code above
