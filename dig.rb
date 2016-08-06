# Array

result = [[[1,2,3]]]
result.dig(0,0,0) #=> 1
result.dig(0,1,2) #=> nil

# Hash

user = {
  user: {
    address: {
      street: '123 Main Street'
    }
  }
}

user.dig(:user, :address, :street) #=> '123 Main Street'
user.dig(:user, :address, :street1) #=> nil

# OpenStruct

address = OpenStruct.new('city' => "Anytown NC", 'zip' => 12345)
person = OpenStruct.new('name' => 'John Smith', 'address' => address)
person.dig(:address, 'zip') #=> 12345
person.dig(:bussiness_address, 'zip') # nil

# ruby patch

class Array
  def dig(index, *indices)
    Array[index, indices].flatten.inject(self) { |result, index| result.send(:[],index) rescue nil }
  end unless Hash.method_defined?(:dig)
end
# array.send(:[], index) == array[index]

class OpenStruct
  def dig(name, *names)
    begin
      name = name.to_sym
    rescue NoMethodError
      raise TypeError, "#{name} is not a symbol nor a string"
    end
    @table.dig(name, *names)
  end unless OpenStruct.method_defined?(:dig)
end

moudle Enumerable
  def dig(arg, *args)
    Array[arg, args].flatten.inject(self) { |result, arg| result.send(:[], arg) rescue nil }
  end unless Enumerable.method_defined?(:dig)
end