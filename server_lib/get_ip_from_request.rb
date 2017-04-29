class IP

  def get_ip
    @ip = request.remote_ip == '127.0.0.1'.freeze ? request.headers['X-REAL_IP'.freeze] : request.remote_ip
  end

end