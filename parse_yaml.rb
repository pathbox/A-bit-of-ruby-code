# encoding: utf-8

require 'yaml'
require 'yaml/store'

# 解析 catalog.yml 文件为一个hash
puts YAML.load_file("./catalog.yml")
puts YAML.load(File.open("./catalog.yml"))


# 把 yaml 转化成字符串

puts YAML.load("--- foo") # => "foo"

# 直接创建一个yaml

puts "="*10

puts YAML.dump("foo") # => "--- foo\n...\n"

puts "="*10
a =  { :a => "b" }.to_yaml # => "---\nA b \n"
puts a

# YAML::Store 可以把对象保存到 yaml 文件里：

Person = Struct.new(:first_name, :last_name)
people = [Person.new("Bob", "Smith"), Person.new("Mary", "Johnson")]

store = YAML::Store.new "person.yml"

store.transaction do
  store["people"] = people
  store["greeting"] = {"hello" => "world"}
end

# 解析上面代码生成的 test.yml，需要事先在 ruby 程序声明 Person 类，否则会报错找不到 module 或 class Person

# 将 Array 或 Hash 转化为 Object（递归)

require 'ostruct'

arr = [["a", 2], ["b", 4]]
hash = {a: "b", c: "d"}

def to_obj(h)
  s = OpenStruct.new
  h.each do |k, v|
    k = k.to_s if !k.respond_to?(:to_sym) && k.respond_to?(:to_s)
    s.new_ostruct_member(k)
    if v.is_a?(Hash)
      v = v["type"] == "hash" ? v["contents"] : to_obj(v)
    elsif v.is_a?(Array)
      v = v.collect{|e| e.instance_of?(Hash) ? to_obj(e) : e}
    end

    s.send("#{k=}".to_sym, v)
  end
  s
end