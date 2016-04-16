class UploadExample
  def upload
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
end