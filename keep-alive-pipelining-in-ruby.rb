#Unfortunately, many standard HTTP libraries revert to HTTP 1.0: one connection, one request. Ruby's own net/http
# uses a little known behavior where by default an "Connection: close" header is appended to each request,
# except when you're using the block form:
#require 'rubygems'
require 'net/http'
#require 'net/http/pipeline'
require 'benchmark'


Benchmark.bm do |x|
  x.report("keepalive") do
    10.times.each do
     Net::HTTP.start('www.baidu.com') do |http|
        r1 = http.get "/?delay=1.5"
        r2 = http.get "/?delay=1.0"
      end
    end
  end

#https://github.com/drbrain/net-http-pipeline

  # x.report("keepalive + pipelining") do
  #   100.times.each do
  #     Net::HTTP.start('www.baidu.com') do |http|
  #       http.pipelining = true
  #       ary = []
  #       ary << Net::HTTP::Get.new('/?delay=1.5')
  #       ary << Net::HTTP::Get.new('/?delay=1.0')
  #
  #       http.pipeline ary do |res|
  #         puts res.code
  #         puts res.body[0..60].inspect
  #       end
  #     end
  #   end
  # end
end
