class Company < ActiveRecord::Base
# ...
end
class Firm < Company
# ...
end
class Client < Company
# ...
end

# Company表中有type 字段代表的是Firm 还是 Client。这是 rails 的约定. type: "Firm"  type: "Client"
# 如果设定`type` 为一个非 Product( 或子类 )的类型, 就会发生异常

p1 = Product.find(1)
p2 = Product.find(1)
p1.name = "Michael"
p1.save
p2.name = "should fail"
p2.save
# 如果别人想再次更改，(脏数据)不会覆盖已经更新过的数据，而是会报错。
# => Raises a ActiveRecord::StaleObjectError