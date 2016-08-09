# ......1. How to check if one Array has all elements of another?

imported_emails = [ 'john@doe.com', 'janet@doe.com' ]
existing_emails = [ 'john@doe.com', 'janet@doe.com' , 'fred@mercury.com' ]

puts 'already imported' if (imported_emails - existing_emails).empty?

# => nil

# ......2. How to find what's elements are common to two Arrays?

tags_post1 = [ 'ruby', 'rails', 'test' ]
tags_post2 = [ 'test', 'rspec' ]

ommon_tags = tags_post1 & tags_post2

#=> ["test"]

# ......3. How to merge two Arrays without duplicating entries?

followeds1 = [ 1, 2, 3 ]
followeds2 = [ 2, 4, 5 ]

all_followeds =  followeds1 | followeds2

#=> => [1, 2, 3, 4, 5]

# ......4. How to sort an Array of Hashes?
# data 数组里面存每个hash 或 json 的结构。这是很常见的一种数据存储结构
data = [
 {
    name: 'Christophe',
    location: 'Belgium'
 },
 {
    name: 'John',
    location: 'United States of America'
 },
 {
    name: 'Piet',
    location: 'Belgium'
 },
 {
    name: 'François',
    location: 'France'
 }
]

data.sort_by { |hsh| hsh[:location] }
# => [
#     {:name=>"Christophe", :location=>"Belgium"},
#     {:name=>"Piet", :location=>"Belgium"},
#     {:name=>"François", :location=>"France"},
#     {:name=>"John", :location=>"United States of America"}
#    ]

# ......5. How to keep objects in an Array that are unique with respect to one attribute?

Product = Struct.new(:id, :category_id)
products = [
 Product.new(1, 1),
 Product.new(2, 2),
 Product.new(3, 3),
 Product.new(4, 1),
 Product.new(5, 3),
 Product.new(6, 5),
]

products = products.uniq &:category_id
#=> [
#     #<struct Product id=1, category_id=1>,
#     #<struct Product id=2, category_id=2>,
#     #<struct Product id=3, category_id=3>,
#     #<struct Product id=6, category_id=5>
#    ]

#......6. How to filter an Array with a String?

books = [
 'The Ruby Programming Language',
 'Programming Ruby 1.9 & 2.0: The Pragmatic Programmers
#039; Guide (The Facets of Ruby)',
 'Practical Object-Oriented Design in Ruby: An Agile Primer',
 'Eloquent Ruby',
 'Ruby on Rails Tutorial: Learn Web Development with Rails'
]

books = books.grep(/[Rr]ails/)

#  => ["Ruby on Rails Tutorial: Learn Web Development with Rails"]

#......7. How to always get an Array?

# In a method you work with products and you eventually return one or several.
#But when you get only one, it's not an Array. You can deal very smoothly with both cases with Array() or [*]:

def method
 # …

 [*products]
end
