# http://www.runoob.com/ruby/ruby-web-services.html
# gem install soap4r
require 'rubygems'
require 'soap/rpc/standaloneserver'

begin
  class SoapServer < SAOP::RPC::StandaloneServer

    def initialize(*args)
      add_method(self, 'add', 'a','b')
      add_method(self, 'div', 'a','b')
    end

    def add(a,b)
      a + b
    end

    def div(a,b)
      a / b
    end
  end


  my_server = MyServer.new("MyServer", 'urn:ruby:calculation', 'localhost', 9000)
  trap('INT'){
    server.shutdown
  }
  my_server.start
rescue => e
  puts e.message
end

