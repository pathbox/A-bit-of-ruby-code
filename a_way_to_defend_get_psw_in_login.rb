#用户登录为了避免遭遇密码暴力破解，我限定了每小时每IP只能尝试登录5次，如果超过5次，拒绝该IP再次尝试登录
#使用了redis 缓存
post :login, :map => '/login' do
  login_tries = $MyRedis.read("#{CACHE_KEY}/login_counter/#{request.ip}")
  halt 403 if login_tries && login_tries.to_i > 5
  @account = Account.new(params[:account])
  if login_account = Account.authenticate(@account.email, @account.password)
    sesssion[:account_id] = login_account.id
    redirect url(:index)
  else
    $MyRedis.increment("#{CACHE_KEY}/login_counter/#{request.ip}", 1, :expires_in => 1.hour)
    render 'home/login'
  end
end