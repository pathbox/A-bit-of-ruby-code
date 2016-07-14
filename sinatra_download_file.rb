# list

get '/' do
	list = Dir.glob("./files/*.*").map{|f| f.split('/').last}
end

# upload
post '/' do
	tempfile = params[:file][:tempfile]
	filename = params[:file][:filename]
	File.copy(tempfile.path, "./files/#{filename}")
	redirect '/'
end

# download
get '/download/:filename' do |filename|
	sned_file "./files/#{filename}", :filename => filename, :type => 'Application/octet-stream'
end

# delete
get '/remove/:filename' do |filename|
	File.delete("./files/#{filename}")
	redirect '/'
end

# 2 download
get '/some/:file' do |file|
	file = File.join('/some/path', file)
	send_file(file, :disposition => 'attachment', :filename => File.basename(file))
end