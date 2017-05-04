require 'uri'
require 'cgi'
url = "www.google.cn?name=curry&age=21&flag=*&nice=%" 

p URI.escape(url)  # 不会编码 & = * 

p URI.encode_www_form_component(url) # 会编码 & = 


#The only difference between this and CGI.escape is that it does not escape `*`

p CGI.escape(url) # 都会编码

