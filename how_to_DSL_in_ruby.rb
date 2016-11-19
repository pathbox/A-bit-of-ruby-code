module Smokestack
  @registry = {}

  def self.registry
    @registry
  end

  def self.define(&block)
    definition_proxy = DefinitionProxy.new
    definition_proxy.instance_eval(&block)
  end

  def self.build(factory_class, overrides = {})
    instance = factory_class.new
    factory = registry[factory_class]
    attributes = factory.attributes.merge(overrides)
    attributes.each do |attribute_name, value|
      instance.send("#{attribute_name}=", value)
    end
    instance
  end
end

class DefinitionProxy
  def factory(factory_class, &block)
    factory = Factory.new
    factory.instance_eval(&block)
    Smokestack.registry[factory_class] = factory
  end
end

class Factory < BasicObject
  def initialize
    @attributes = {}
  end

  attr_reader :attributes

  def method_missing(name, *args, &block)
    @attributes[name] = args[0]
  end
end

class User
  attr_accessor :name, :pet_name
end

Smokestack.define do
  factory User do
    name "Gabe BW"
    pet_name "Toto"
  end
end

user = Smokestack.build(User)
puts user.name
#=> "Gabe BW"
puts user.pet_name
#=> "Toto"

other_user = Smokestack.build(User, name: 'Bob')
puts other_user.name
#=> "Bob"
puts other_user.pet_name
#=> "Toto"
