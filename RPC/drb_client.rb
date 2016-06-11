require 'drb'

class DrbClient
  def run
    DRb.start_service()
    obj = DRbObject.new(nil, 'druby://localhost:9000')
    sum = obj.add(1,2,3,4,5,6)
    puts "Sum is : #{sum}"
  end
end

client = DrbClient.new
client.run