namespace :grape do
  desc "routes"
  task :routes => :environment do
    API.routes.map { |route| puts "#{route} \n" }
    AgentApis::V1::Root.routes.map { |route| puts "#{route} \n" }
  end
end

##gentApis::V1::Root.routes
#API.routes
