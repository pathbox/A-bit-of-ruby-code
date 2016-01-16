def m1
  "string"*1000
end

def m2
 a= "string"*1000
# p a
end

def start
  n =0
  n = n+1 while n< 100_000
  
  100_000.times do
    m1
    m2
  end
end

start
