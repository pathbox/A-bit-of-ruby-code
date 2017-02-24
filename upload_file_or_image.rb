class UploadExample
  # it is not work
  def upload_image
    file = "./u.png"

    header = {"Content-Type" => "multipart/form-data, boundary=#{BOUNDARY}"}
    post_body = []
    post_body << "--#{BOUNDARY}\r\n"
    post_body << "Contetn-Disposition: form-data;name=\"user[photo]\";filename=\"#{File.basename(file)}\"\r\n"
    post_body << "Content-Type: image/png\r\n\r\n"
    post_body << File.read(file)  #图片被read成二进制数据保存到post_body数组中
    post_body << "\r\n\r\n--#{BOUNDARY}--\r\n"
    uri = URI.parse("#{ROOT}/api/userphoto_update?client_uuid=#{CUUID}&latitude=#{LATITUDE}&longitude=#{LONGITUDE}")
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Put.new(uri.request_uri,header)
    req.body = post_body.join
    req.basic_auth("#{LOGINNAME}", "#{PASSWORD}")
    r = http.request(req)  #最后把req发送到uri中,完成图片的上传。uri是一个api接口

    if r.code.to_i == 200
      $messages = $messages + "\n" if $messages != ""
      $messages = $messages + "#{api_type} OK - #{r.code}: #{r.message}"
    else
      $messages = $messages + "\n" if $messages != ""
      $messages = $messages + "#{api_type} WARNING - #{r.code}: #{r.message}"
    end
  end

  # it is work file_io 为前端 multpart/form-data 方式表单上传到后台的 上传文件，被rails封装成了一个file对象，实际上在/tmp目录会有临时文件产生
  # #<ActionDispatch::Http::UploadedFile:0x007f27e4822248
  #     @content_type="audio/wav",
  #     @headers="Content-Disposition: form-data; name=\"voice_file\"; filename=\"green.wav\"\r\nContent-Type: audio/wav\r\n",
  #     @original_filename="green.wav",
  #     @tempfile=#<File:/tmp/RackMultipart20170224-20685-hnjosp>
  def upload_voice(file_io)
    host          = resource_api_host
    account_sid   = account_sid
    auth_token    = auth_token
    timestamp     = Time.now.strftime('%Y%m%d%H%M%S')
    signature     = Digest::SHA1.hexdigest("#{account_sid}#{auth_token}#{timestamp}")
    app_id        = app_id
    path          = "server/url/to/upload"
    url           = URI("http://#{host}/#{path}?timestamp=#{timestamp}&app_id=#{app_id}")
    authorization = Base64.encode64("#{account_sid}:#{signature}").gsub(/\n/, '').strip
    headers       = "Basic #{authorization}" # 使用了headers 的 http_basic 验证接口

    request = Net::HTTP::Post::Multipart.new(
                                              url,
                                              {
                                                "uploadfile": => UploadIO.new(file_io.tempfile, "", "#{file_io.original_filename}")
                                              }
                                            )
    request["Authorization"] = "Basic #{authorization}"
    response = Net::HTTP.start(url.host, url.port, read_timeout: 5) do |http|
      http.request(req)
    end
    puts response

    return JSON.parse(response.read_body).deep_symbolize_keys
  end

  # 下面的没有被验证过
  def example1
    require 'rest_client'
    RestClient.post('http://localhost:3000/foo',
                    :name_of_file_param => File.new('/path/to/file'))
  end

  def example2
    data, headers = Multipart::Post.prepare_query("title" => my_string, "document" => my_file)
    http = Net::HTTP.new(upload_uri.host, upload_uri.port)
    res = http.start {|con| con.post(upload_uri.path, data, headers) }
  end

  def curl
    `curl -F media=@#{photo.path} -F username=#{@username} -F password=#{@password} -F message='#{photo.title}' http://twitpic.com/api/uploadAndPost`
  end

end