require 'ostruct'

icecream = OpenStruct.new
icecream.flavor = "strawberry"
puts "The flavor: #{icecream.flavor}"

# OpenStruct 类来自于Ruby标准库，它看起来有点神奇。一个OpenStruct对象的属性用起来就像是Ruby的变量。
# 如果想要一个新属性，那么只需要给它赋个值就行了，然后它就奇迹般的存在了
# 其中就用到了method_missing 的原理
