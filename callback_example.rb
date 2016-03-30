CALLBACKS = [
    :after_initialize, :after_find, :after_touch,
    :before_save, :around_save, :after_save,
    :before_create, :around_create, :after_create,
    :before_update, :around_update, :after_update,
    :before_destroy, :around_destroy, :after_destroy,
    :before_validation, :after_validation,
    :after_commit, :after_rollback,
    :after_create_commit, :after_update_commit, :after_destroy_commit
]

# 调用方式主要有以下几种:
#     1. 宏定义的方式，后面跟方法名进行调用
#     2. 传递一个可回调对象
#     3. 以类方法的形式，传递一个 block

# 1 宏定义的方式，后面跟方法名进行调用
class Topic < ActiveRecord::Base
  before_destroy :delete_parents
  private
  def delete_parents
    self.class.delete_all "parent_id = #{id}"
  end
end

# 2 传递一个可回调对象
class BankAccount < ActiveRecord::Base
  before_save EncryptionWrapper.new
  after_save EncryptionWrapper.new
  after_initialize EncryptionWrapper.new
end
class EncryptionWrapper
  def before_save(record)
    record.credit_card_number = encrypt(record.credit_card_number)
  end
  def after_save(record)
    record.credit_card_number = decrypt(record.credit_card_number)
  end
  alias_method :after_initialize, :after_save
  private
  def encrypt(value)
# Secrecy is committed
  end
  def decrypt(value)
# Secrecy is unveiled
  end
end

# 2 传递一个可回调对象
class BankAccount < ActiveRecord::Base
  before_save EncryptionWrapper.new("credit_card_number")
  after_save EncryptionWrapper.new("credit_card_number")
  after_initialize EncryptionWrapper.new("credit_card_number")
end
class EncryptionWrapper
  def initialize(attribute)
    @attribute = attribute
  end
  def before_save(record)
    record.send("#{@attribute}=", encrypt(record.send("#{@attribute}"))
  end
  def after_save(record)
    #...
  end
  def after_initialize(record)
    # ...
  end
  alias_method :after_initialize, :after_save

  private
  def encrypt(value)
    # Secrecy is committed
  end
  def decrypt(value)
    # Secrecy is unveiled
  end
end

# 3 以类方法的形式，传递一个 block
class Napoleon < ActiveRecord::Base
  before_destroy { logger.info "Josephine..." }
  before_destroy do
# some code
  end
# ...
end

def around_save
# 类似 before save ...
  yield # 执行 save
# 类似 after save ...
end

# 回调及其顺序
# 每个操作，它所对应的回调(按顺序来的)。
# 创建
# before_validation
# after_validation
# before_save
# around_save
# before_create
# around_create
# after_create
# after_save
# after_commit/after_rollback
# 更新
# before_validation
# after_validation
# before_save
# around_save
# before_update
# around_update
# after_update
# after_save
# after_commit/after_rollback
# Rails 5 开发进阶(Beta)
# 回调及其顺序 514
# 删除
# before_destroy
# around_destroy
# after_destroy
# after_commit/after_rollback
# save = create + update
# commit = create + update + destroy 自然地也包含了 save 在内

# transaction 中, 异常错误中断时， after_commit不会执行， after_save会继续执行。所以，一般用after_commit

# after_initialize 和 after_find
# 不管是直接 new 或其它途径，只要有对象被初始化，就会触发 after_initialize 回
# 调。使用它，可以避免重写 initialize 方法。
# 只要从数据库里查找记录，就会触发 after_find 回调。并且，after_find 和
# after_initialize 同时定义的时候，after_find 优先级要高于 after_initialize.initalize 和 find
# 只有 after* 回调，也就是 after_initialize 和 after_find callbacks，没
# 有对应的 before* 回调。

# after_touch

class User < ActiveRecord::Base
  after_touch do |user|
    puts "You have touched an object"
  end
end
# 在 belongs_to 关联里，除 touch: true 外，使用 after_touch 可以做更多的操作

class Employee < ActiveRecord::Base
  belongs_to :company, touch: true
  after_touch do
    puts 'An Employee was touched'
  end
end
class Company < ActiveRecord::Base
  has_many :employees
  after_touch :log_when_employees_or_company_touched
  private
  def log_when_employees_or_company_touched
    puts 'Employee/Company was touched'
  end
end

class Order < ActiveRecord::Base
  before_save :normalize_card_number, if: :paid_with_card?
end
class Order < ActiveRecord::Base
  before_save :normalize_card_number, if: "paid_with_card?"
end
class Order < ActiveRecord::Base
  before_save :normalize_card_number,
              if: Proc.new { |order| order.paid_with_card? }
end
class Comment < ActiveRecord::Base
  after_create :send_email_to_author, if: :author_wants_emails?,
               unless: Proc.new { |comment| comment.article.ignore_comments? }
end






































