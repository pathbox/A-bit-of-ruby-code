class Book < ActiveRecord::Base
  has_one :author
  has_many :pages
  accepts_nested_attributes_for :author, :pages
end

# 三个重要的点
当 nested_attributes:{} 中没传 id，或 id: nil 则表示嵌套新建 create操作
当 nested_attributes:{} 中没传 id 则表示嵌套更新 update操作
当 nested_attributes:{} 中传 id 和 _destroy: '1',和配置 allow_destroy: true， 则表示嵌套删除 destroy操作

# One to One

class Member < ActiveRecord::Base
  has_one :avatar
  accepts_nested_attributes_for :avatar
end

params = {
  member: { name: 'Jack',
            avatar_attributes: { icon: 'smiling'}
            }
          }

member = Member.create(params[:member])
member.avatar.id  #=> 2
member.avatar.icon #=> 'smiling'

class Member < ActiveRecord::Base
  has_one :avatar
  accepts_nested_attributes_for :avatar, allow_destroy: true
end

member.avatar_attributes = { id: '2', _destroy: '1' }
member.avatar.marked_for_destruction? # => true
member.save
member.reload.avatar # => nil

# One to many

class Member < ActiveRecord::Base
  has_many :posts
  accepts_nested_attributes_for :posts
end

params = { member: {
  name: 'joe', posts_attributes: [
    { title: 'Kari, the awesome Ruby documentation browser!' },
    { title: 'The egalitarian assumption of the modern citizen' },
    { title: '', _destroy: '1' } # this will be ignored
  ]
}}

member = Member.create(params[:member])
member.posts.length # => 2
member.posts.first.title # => 'Kari, the awesome Ruby documentation browser!'
member.posts.second.title # => 'The egalitarian assumption of the modern citizen'

class Member < ActiveRecord::Base
  has_many :posts
  accepts_nested_attributes_for :posts, reject_if: proc {|attribute| attribute['title'].blank?}
end

params = { member: {
  name: 'joe', posts_attributes: [
    { title: 'Kari, the awesome Ruby documentation browser!' },
    { title: 'The egalitarian assumption of the modern citizen' },
    { title: '' } # this will be ignored because of the :reject_if proc
  ]
}}

member = Member.create(params[:member])
member.posts.length # => 2
member.posts.first.title # => 'Kari, the awesome Ruby documentation browser!'
member.posts.second.title # => 'The egalitarian assumption of the modern citizen'

class Member < ActiveRecord::Base
  has_many :posts
  accepts_nested_attributes_for :posts, reject_if: :new_record?
end

class Member < ActiveRecord::Base
  has_many :posts
  accepts_nested_attributes_for :posts, reject_if: :reject_posts

  def reject_posts(attributes)
    attributes['title'].blank?
  end
end

By default the associated records are protected from being destroyed. If you want to destroy any of the associated records through the attributes hash, you have to enable it first using the :allow_destroy option. This will allow you to also use the _destroy key to destroy existing records:

class Member < ActiveRecord::Base
  has_many :posts
  accepts_nested_attributes_for :posts, allow_destroy: true
end

params = { member: {
  posts_attributes: [{ id: '2', _destroy: '1' }]
}}

member.attributes = params[:member]
member.posts.detect { |p| p.id == 2 }.marked_for_destruction? # => true
member.posts.length # => 2
member.save
member.reload.posts.length # => 1
Nested attributes for an associated collection can also be passed in the form of a hash of hashes instead of an array of hashes:

Member.create(
  name: 'joe',
  posts_attributes: {
    first:  { title: 'Foo' },
    second: { title: 'Bar' }
  }
)
has the same effect as

Member.create(
  name: 'joe',
  posts_attributes: [
    { title: 'Foo' },
    { title: 'Bar' }
  ]
)
