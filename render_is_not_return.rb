def create
  user = User.Create(params)
	code = user ? 200 : 500
	render :json => {code: code}
	UserExampleWorker.perform_async(params)  # 上面及时render了，这一句也会继续执行下去。redirect_to 和这里类似
end
