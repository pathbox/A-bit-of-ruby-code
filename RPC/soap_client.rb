#!/usr/bin/ruby -w

require 'soap/rpc/driver'
NAMESPACE = 'urn:ruby:calculation'
URL = 'http://localhost:9000/'

begin
  driver = SOAP::RPC::Driver.new(URL, NAMESPACE)

  driver.add_method('add', 'a', 'b')

  puts driver.add(20,30)

rescue => e
  puts e.message
end