require 'rest-client'

response = RestClient.get 'http://www.baidu.com'

#r2 = RestClient.get 'http://www.baidu.com', {:params =>{:id => 1,'foo'=> 'bar'}}
#r3 = RestClient.get 'https://www.baidu.com', {:accept => :json}

#r4 = RestClient.post 'http://www.baidu.com', :username => 'hello', :password => '123456'

#r5 = RestClient.post "http://example.com/resource", { 'x' => 1 }.to_json, :content_type => :json, :accept => :json

#r6 = RestClient.delete 'http://www.baidu.com'
#response.code
#response.cookies
#reponse.headers
#response.to_str
#RestClient.
#  post( url,
 #                {
  #    :transfer => {
   #     :path => '/foo/bar',
    #          :owner => 'that_guy',
     #               :group => 'those_guys'
   # },
       #    :upload => {
    #        :file => File.new(path, 'rb')
     #   }
      #    })
var = response.headers
p var
