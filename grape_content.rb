namespace :statuses do
	params do
		requires :user_id, type: Integer, desc: 'A user ID'
	end
	namespace ':user_id' do
		desc "retrueve a user's status"
		params do
			requires :status_id, type: Integer, desc: 'A status ID'
			get ':status_id' do
				User.find(params[:user_id]).statuses.find(params[:status_id])
			end
		end
	end
end

namespace :statuses do
  route_param :id do
  	desc 'return all replies for a status'
  	get 'replies' do
  	  Status.find(params[:id]).replies
  	end
  	desc 'return a status'
  	get do
  	  Status.find(params[:id])
  	end
  end
end

namespace :status do
  route_param :id do
    desc 'return all replies for a status'
    get 'replies' do # => '/status/:id/replies'
      Status.find(params[:id]).replies
    end
    desc 'return a status'
    get do # => '/status/:id'
      Status.find(params[:id])
    end
  end
end


get do
  error!('Unauthorized', 401) unless headers['Secret-Password'] == 'swordfish'
end

get do
  error!('Unauthorized' , 401) unless env['HTTP_SECRET_PASSWORD'] == 'swordfish'
end

header 'X-Robots-Tag', 'noindex'

get ':id', requirements: { id: /[0-9]*/ } do
  Status.find(params[:id])
end

namespace :outer, requirements: { id: /[0-9]*/ } do
  get :id do # '/outer/:id'
  end

  get ':id/edit' do # '/outer/:id/edit'
  end
end

module StatusHelpers
  def user_info(user)
  	"#{user} has statused #{user.statuses} status"
  end
end

class API < Grape::API
  helpers do
  	def current_user
  	  User.find(params[:user_id])
  	end
  end
end

# or mix in a module

helpers StatusHelpers

get 'info' do # '/info'
  user_info(current_user) # controller
end

# pagination params
class API < Grape::API
  helpers do
    params :pagination do
      optional :page, type: Integer  #optonal means it is not must be required
      optional :per_page, type: Integer
    end
  end

  desc 'get collection'
  params do
    use :pagination  # it include tow (some) params. aliases: includes, use_scope
  end
  get do
    Collection.page(params[:page]).per(params[:per_page])
  end
end

#using shared helpers

module SharedParams
  extend Grape::API::Helpers

  desc 'Get Collection'
  params do
  	use :period, :pagination
  end

  get do
  	Collection
  	  .from(paras[:start_date])
  	  .to(prams[:end_date])
  	  .page(params[:page])
  	  .per(prams[:per_page])
  end
end

module SharedParams
  extend Grape::API::Helpers

  params :order do |optoins|
    optional :order_by, type:Symbol, values:options[:order_by], default:options[:default_order_by]
    optional :order, type:Symbol, values:%i(asc desc), default:options[:defaulr_order]
  end
end

class API < Grape::API
  helpers SharedParams

  desc 'Get a sorted Collection'
  params do
    use :order, order_by:%i(id created_at), default_order_by: :created_at, default_order_by: :created_at
  end
  get do
  	Collection.send(params[:order], params[:order_by])
  end
end

#You can attach additional documentation to params using a documentation hash.

params do
  optional :first_name, type: String, documentation: { example: 'Jim' }
  requires :last_name, type: String, documentation: { example: 'Smith' }
end

# Cookies

class API < Grape::API
  get 'status_count' do  # '/status_count'
    cookies[:status_count] ||= 0
    cookies[:status_count] += 1
    { status_count: cookies[:status_count]} # return this hash
  end
end

#Use a hash-based syntax to set more than one value.

cookies[:status_count] = {
  value: 0,
  expires: Time.tomorrow,
  domain: '.twitter.com',
  path: '/'
}

#Delete a cookie with delete
cookies.delete :status

#Specify an optional path.
cookies.delete :status_count, path: '/'


# HTTP Status Code
# You can use status to query and set the actual HTTP Status Code
post do
  status 202

  if status == 200

  end
end

# redirect

redirect '/statuses'

redirect '/statuses', permanent: true

#Raising Exceptions

  error! 'Access Denied', 401

  error!({error: 'unexpected error', detail: 'missing widget'}, 500)

module API
  class Error < Grape::Entity
  	expose :code
  	expose :message
  end
end

class API < Grape::API
  default_error_status 500
  get '/example' do
  	error! 'This should have http status code 500'
  end
end

# Exception Handling

class Twitter::API < Grape::API
  rescue_from :all
  rescue_from ArgumentError, UserDefindedEorror
end

class Twitter::API < Grape::API
  error_formatter :txt, ->（message, backtrace, options, env）{
  	"error: #{message} from #{backtrace}"
  }
end

class Twitter::API < Grape::API
  rescue_from :all do |e|
  	Rack::Response.new([e.message], 500, { 'Content-type'=>'text/error'}).finish
  end
end


# Logger
# Grape::API provides a logger method which by default will return an instance of the Logger class from Ruby's standard library.
#To log messages from within an endpoint, you need to define a helper to make the logger available in the endpoint context.
class API < Grape::API
  helpers do
    def logger
      API.logger # logger class method
    end
  end
  post '/statuses' do
  	logger.info "#{current_user} has statused"
  end
end

# own logger

class MyLogger
  def warning(message = nil)
  	puts "this is a warning: #{message}"
  end
end

class API < Grape::API
  logger MyLogger.new
  helpers do
  	def logger
  	  API.logger
  	end
  end
end



















































