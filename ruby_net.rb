require 'net/http'

#uri = URI("http://www.baidu.com")
#res = Net::HTTP.get(uri)
#
#params = {:limit => 10, :offset => 3}

#uri = URI("http://httpbin.org/get")
#uri.query = URI.encode_www_form(params)

uri = URI('http://httpbin.org/post')


#res = Net::HTTP.get_response(uri)

res = Net::HTTP.post_form(uri, :q => 'ruby')

puts res.body

puts res.code
