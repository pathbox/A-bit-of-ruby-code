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