#!/usr/bin/env ruby
# encoding: utf-8

# one-to-one  point-to-point

require "rubygems"
require "bunny"

STDOUT.sync = true


conn = Bunny.new
conn.start
#connects to RabbitMQ running on localhost, with the default port (5672), username ("guest"), password ("guest") and virtual host ("/").

ch = conn.create_channel
q = ch.queue("bunny.examples.hello_world", :auto_delete => true) #this means that the queue will be deleted when there are no more processes consuming messages from it.
x = ch.default_exchange # use default exchange

q.subscribe do |delivery_info, metadata, payload|
  puts "Received #{payload}"
end
# Routing key is one of the message properties. The default exchange will route the message to a queue
# that has the same name as the message's routing key. This is how our message ends up in the "bunny.examples.hello_world" queue
x.publish("Hello!", :routing_key => q.name) # routing_key == queue_name

sleep 0.1
conn.close

# one-to-many  broadcast

#The previous example demonstrated how a connection to a broker is made and how to do 1:1 communication using the default exchange.
# Now let us take a look at another common scenario: broadcast, or multiple consumers and one producer

STDOUT.sync = true

conn = Bunny.new("amqp://guest:guest@localhost:5672")
conn.start

ch = conn.create_channel
#Blabbr members use a fanout exchange for publishing, so there is no need to specify a message routing key
# because every queue that is bound to the exchange will get its own copy of all messages, regardless of the queue name and routing key used
x = ch.fanout("nba.scores") # use nba.scores exchange

# queue_name don't care about the routing_key, every queue can get all from exchange
ch.queue("joe", :auto_delete => true).bind(x).subscribe do |delivery_info, metadata, payload|  # payload is message body
  puts "#{payload} => joe"
end

ch.queue("aaron", :auto_delete => true).bind(x).subscribe do |delivery_info, metadata, payload|
  puts "#{payload} => aaron"
end

x.publish("BOS 101, NYK 89").publish("ORL 85, ATL 88")

conn.close

# many-to-many  topic exchanges

#Our third example involves weather condition updates. What makes it different from the previous two examples is that not all of the consumers are interested in all of the messages.
# People who live in Portland usually do not care about the weather in Hong Kong (unless they are visiting soon).
# They are much more interested in weather conditions around Portland, possibly all of Oregon and sometimes a few neighbouring states.

STDOUT.sync = true

connection = Bunny.new
connection.start

channel = connection.create_channel

# topic exchange name can be any string

exchange = channel.topic("weather", :auto_delete => true)

# Subscribers

channel.queue("", :exclusive => true).bind(exchange, :routing_key => "americas.north.#").subscribe do |delivery_info, metadata, payload|
  puts "An update for North America: #{payload}, routing key is #{delivery_info.routing_key}"
end

channel.queue("americas.south").bind(exchange, :routing_key => "americas.south.#").subscribe do |delivery_info, metadata, payload|
  puts "An update for South America: #{payload}, routing key is #{delivery_info.routing_key}"
end
channel.queue("us.california").bind(exchange, :routing_key => "americas.north.us.ca.*").subscribe do |delivery_info, metadata, payload|
  puts "An update for US/California: #{payload}, routing key is #{delivery_info.routing_key}"
end
channel.queue("us.tx.austin").bind(exchange, :routing_key => "#.tx.austin").subscribe do |delivery_info, metadata, payload|
  puts "An update for Austin, TX: #{payload}, routing key is #{delivery_info.routing_key}"
end
channel.queue("it.rome").bind(exchange, :routing_key => "europe.italy.rome").subscribe do |delivery_info, metadata, payload|
  puts "An update for Rome, Italy: #{payload}, routing key is #{delivery_info.routing_key}"
end
channel.queue("asia.hk").bind(exchange, :routing_key => "asia.southeast.hk.#").subscribe do |delivery_info, metadata, payload|
  puts "An update for Hong Kong: #{payload}, routing key is #{delivery_info.routing_key}"
end

exchange.publish("San Diego update", :routing_key => "americas.north.us.ca.sandiego").
    pulish("Berkeley update", :routing_key => "americas.north.us.ca.berkeley").
    publish("San Francisco update",    :routing_key => "americas.north.us.ca.sanfrancisco").
    publish("New York update",         :routing_key => "americas.north.us.ny.newyork").
    publish("São Paolo update",        :routing_key => "americas.south.brazil.saopaolo").
    publish("Hong Kong update",        :routing_key => "asia.southeast.hk.hongkong").
    publish("Kyoto update",            :routing_key => "asia.southeast.japan.kyoto").
    publish("Shanghai update",         :routing_key => "asia.southeast.prc.shanghai").
    publish("Rome update",             :routing_key => "europe.italy.roma").
    publish("Paris update",            :routing_key => "europe.france.paris")

sleep 0.1

connection.close























