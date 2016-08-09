#........... 1. How to convert a JSON into a Hash?


data = "{\"name\": \"Stven Curry\",\"team\": \"warrior\", \"location\": \"The Golden State\"}"

require 'json'

profile = JSON.parse(data)

#=> {"name"=>"Stven Curry", "team"=>"warrior", "location"=>"The Golden State"}


# .........2. How to convert a Hash into a JSON?
signups_of_the_week = {
    Monday: 2,
    Tuesdat: 3,
    Wednesday: 3,
    Thursday: 20,
    Friday: 56,
    Saturday: 20,
    Sunday: 22
}

require 'json'

data_s = signups_of_the_week.to_json

#=> "{\"Monday\":2,\"Tuesdat\":3,\"Wednesday\":3,\"Thursday\":20,\"Friday\":56,\"Saturday\":20,\"Sunday\":22}"

JSON.parse(data_s)

#=> {"Monday"=>2, "Tuesdat"=>3, "Wednesday"=>3, "Thursday"=>20, "Friday"=>56, "Saturday"=>20, "Sunday"=>22}

# .............3. How to set default value for a nested Hash?
contacts = {
  "John" => { name: "John", email: "john@doe.com" },
  "Freddy" => { name: "Freddy", email: "freddy@mercury.com" }
}

contacts["Jane"] = {}
contacts["Jane"][:email] = "jane@doe.com"
puts contacts["Jane"]
#=>  {:email=>"jane@doe.com"}

contacts = Hash.new do |hash, key|
  hash[key] = {
      name: key,
      email: "#{key}@163.com"
  }
end

contacts['curry']
contacts
#=> {:name=>"curry", :email=>"curry@163.com"}
#=> {"curry"=>{:name=>"curry", :email=>"curry@163.com"}}

# or later with

contacts.default_proc = Proc.new do |hash, key|
  hash[key] = {
      name: key,
      email: '#{key}@163.com'
  }
end

# 对于嵌套hash 的构造创建, 这种方法很好很强大

#............4. How to merge two nested Hashes?

wish_list = {
  8 => { title: 'The Color of Magic', },
  42 => { title: 'The Hitch-Hiker"s Guide to the Galaxy', price: 5 }
}
basket = {
  8 => { price: 10 },
  1729 => { title: 'Ramanujan: Twelve Lectures on Subjects Suggested by His Life and Work', price: 28 }
}

require "active_support/core_ext/hash" # not necessary if in Rails

basket.deep_merge(wish_list)

# or without ActiveSupport

def deep_merge(h1, h2)
  h1.merge(h2) { |key, h1_elem, h2_elem| deep_merge(h1_elem, h2_elem)}
end

deep_merge(h1, h2)

#=> {8=>{:price=>10, :title=>"The Color of Magic"},
#    1729=>{:title=>"Ramanujan: Twelve Lectures on Subjects Suggested by His Life and Work", :price=>28},
#    42=>{:title=>"The Hitch-Hiker\"s Guide to the Galaxy", :price=>5}}

# ...........5. How to filter out some keys of a Hash?

histogram = { monday: 5, tuesday: 7, wednesday: 10, thursday: 18, friday: 7, saturday: 2, sunday: 0 }

# You want to filter out Saturday and Sunday. With ActiveSupport,  you can do it as following
histogram.except(:saturday, :sunday)
#=>   {:monday=>5, :tuesday=>7, :wednesday=>10, :thursday=>18, :friday=>7}

# without ActiveSupport
def filter(hash, *keys)
  hash.dup.tap do |h|
    keys.each { |k| h.delete(k) }
  end
end

def filter2(hash, *keys)
  hash.reject { |k, _| key.include? k }
end

# .........6. How to "sort" a Hash by value?

scores = { "The Lady" => 3, "Fate" => 20, "Death" => 10 }

leaderboard = scores.sort_by { |_, score| -score } # 根据score 排序 倒序

# => [["Fate", 20], ["Death", 10], ["The Lady", 3]]

# ..........7. How to find the differences between two Hashes?

entries = { 1372284000 => 'CVE-2013-4073', 1368482400 => 'CVE-2013-2065' }
updated_entries = { 1385074800 => 'CVE-2013-4164', 1372284000 => 'CVE-2013-4073', 1368482400 => 'CVE-2013-2065' }

new_entries = updated_entries.reject { |k, _| entries.include? k }

#=> {1385074800=>'CVE-2013-4164'}  找出新增的key => value
