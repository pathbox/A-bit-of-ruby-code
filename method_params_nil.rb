# 关于method 中 nil 参数的问题

def method_1(a,b,c=nil)
  puts a,b,c
end

method_1(1,2)

def method_2(a,b,c=nil,d=nil)
  puts a,b,c,d
end

d = 3
method_2(1,2,d)

#当method中使用了多个参数默认值为nil时，此时不想传c，想传a，b，d。就需要为c传nil

def method_3(a,b,c=nil,d=nil)
  puts a,b,c,d
end

d = 3
method_3(1,2,nil,d)
