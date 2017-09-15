require 'concurrent'

account1 = Concurrent::TVar.new(100)
account2 = Concurrent::TVar.new(100)

Concurrent::atomically do
  account1.value -= 10
  account2.value += 10
end

puts "Account1: #{account1.value}, Account2: #{account2.value}"