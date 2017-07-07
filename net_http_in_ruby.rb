uri = URI("#{url}?#{params.to_query}")
req = Net::HTTP::Get.new(uri)
req['Content-Type']   = 'application/xml'
Net::HTTP.start(uri.host, uri.port, read_timeout: 10) do |http|
  res = http.request req # Net::HTTPResponse object
end
res = res.body

# 使用ruby 原生的 Net::HTTP 作为http client， 并且加入了超时机制
