require 'nokogiri'
require 'open-uri'
require 'net/http'


# uri = URI('http://example.com/index.html?count=10')
# Net::HTTP.get(uri) # => String
url = "http://www.baidu.com"

# def HTML thing, url = nil, encoding = nil, options = XML::ParseOptions::DEFAULT_HTML, &block
#   Nokogiri::HTML::Document.parse(thing, url, encoding, options, &block)
# end
a = open(url) #<File:0x007fa4d2ac1740>
data = Nokogiri::HTML(open(url),"GB18030")

# puts data.at_css('div#wrapper div#head div.head_wrapper div#u1 a.mnav').text.strip # just first a.mnav
# puts data.css('div#wrapper div#head div.head_wrapper div#u1 a.mnav').text.strip # all a.mnav


doc = data.css('div#wrapper div#head div.head_wrapper div#u1 a.mnav')

doc.map{|d| puts d.content} # 新闻 hao123 地图 视频 贴吧

# puts a.entries

####
# Search for nodes by css
# doc.css('p > a').each do |a_tag|
#   puts a_tag.content
# end

# ####
# # Search for nodes by xpath
# doc.xpath('//p/a').each do |a_tag|
#   puts a_tag.content
# end

# ####
# # Or mix and match.
# doc.search('//p/a', 'p > a').each do |a_tag|
#   puts a_tag.content
# end

# ###
# # Find attributes and their values
# doc.search('a').first['href']

# def rm_style doc
#   doc.search("img").each{|i| i.set_attribute('class', nil)}
# end

# url = li.css("a").attr("href").to_s rescue nil # attr 方法

# published_at = Time.zone.parse(li.css("span").text) rescue nil #将字符串 转换为 datetime


content = Nokogiri::HTML(http_get(url), nil, GB18030).css("#{ContentBody p}")[0..-2]





























