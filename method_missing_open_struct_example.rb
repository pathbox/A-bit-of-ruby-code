class MyOpenStrruct
  def initialize
    @attributes = {}
  end

  def method_missing(name, *args)
    puts args
    puts name # method's name  getter and setter
    attribute = name.to_s
    if attribute =~ /=$/
      @attributes[attribute.chop] = args[0]
    else
      @attributes[attribute]
    end
  end
end

puts MyOpenStrruct.new.attributes
icecream = MyOpenStrruct.new
p icecream.flavor # nil
icecream.flavor = "vanilla"
puts "The flavor: #{icecream.flavor}"
