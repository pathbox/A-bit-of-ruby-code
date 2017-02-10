set :application, "APPNAME"
set :repository, "git@github.com:YOU/APPNAME.git"
ssh_options[:forward_agent] = true
set :user, 'USERNAME'
set :deploy_to, "/home/#{user}/app"
set :gopath, deploy_to
set :pid_file, deploy_to+'/pids/PIDFILE'
set :symlinks, { "pids" => "pids" }

task :staging do
  server "1.stage.example.com", :app
end

task :production do
  server '1.app.example.com', :app
  server '2.app.example.com', :app
end

after 'deploy:update_code', 'go:build'

namespace :go do
  task :build do
    with_env('GOPATH', gopath) do
      run "go get -u github.com/YOU/APPNAME"
      run "mkdir #{release_path}/bin"
      run "cp /home/#{user}/go/bin/APPNAME #{release_path}/bin/"
    end
  end
end