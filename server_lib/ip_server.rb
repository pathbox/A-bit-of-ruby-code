class IPServer

  API_URL = 'http://freeapi.ipip.net'

  def initialize(ip)
    @ip = ip
  end

  # returns:
  #   [
  #     "中国",  // 国家
  #     "天津",  // 省会或直辖市（国内）
  #     "天津",  // 地区或城市 （国内）
  #     "",     // 学校或单位 （国内）
  #     "联通",  // 运营商字段
  #   ]

  def location
    @location ||= begin
      cached_request
    end
  end

  # https://www.ipip.net/api.html 已升级为收费
  # curl "http://ipapi.ipip.net/find?addr=118.28.8.8" -H "Token: my_token"
  # NOTICE: ipip由于受到攻击,把ua为Ruby开头的封掉了,RestClient默认为Ruby的Ua
  Header = {"Token" => my_token, "User-Agent" => "curl"}
  ApiUrl = "http://ipapi.ipip.net/find"
  IpExpireTime = 60.days

  def cached_request
    redis_get_ip(@ip) or \
    begin
      url = "#{ApiUrl}?addr=#{@ip}"
      res = JSON.parse RestClient::Request.execute(method: :get, url: url, headers: Header, timeout: 1)
      data = res['data'][0..4]
      redis
    rescue Exception => e
      e.error_log("IPIP ERROR: #{@ip}")
      ["", "", "", "", ""].freeze
    end
  end

  def redis_set_ip(ip,data)
    redis.set("IPIP:#{ip}", data.to_json, ex: IpExpireTime)
  end
  def redis_get_ip(ip)
    redis.get("IPIP:#{ip}").presence.try do |data|
      return JSON.parse(data) rescue nil
    end
  end
  def self.ipip_status
    JSON.parse RestClient::Request.execute(:method => :get, :url => "#{ApiUrl}_status", :headers => Header, :timeout => 1)
  end

  def unknown?
    location.all?(&:blank?)
  end

  def local?
    ["局域网"].include?(location.first)
  end

  def human_name
    if unknown?
      '未知IP'
    elsif local?
      "局域网"
    else
      location.reject { |element| element.eql?('中国') }.uniq.join
    end
  end

  # TODO: 和 phone_info 表里的省名称一致
  def province
    (unknown? || local?) ? "" : location[1]
  end

  # TODO: 和 phone_info 表里的市名称一致
  def city
    (unknown? || local?) ? "" : location[2]
  end

  def service_provider
    (unknown? || local?) ? "" : location[4]
  end
  def redis
    $imv4_redis
  end

end
