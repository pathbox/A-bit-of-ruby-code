require 'action_controller/parameters'
require 'action_controller/parametters'
params = ActionControlelr::Parameters.new({
		person:{
			name: 'France',
			age: 22,
			role: 'admin'
		}
	})

permitted = params.require(:person).permit(:name,:age) # 只传进了name，age

permitted  # => {"name"=>"France", "age"=>22}
permited.class # => ActionController::Parameters
permit!
@user.update_attributes(params[:user].permit!)
config.always_permitted_parameters = %( controller action format )
permitted.permitted? # => true

@user.attributes # 可以认为是一个hash,里面的key是数据库对应的字段名

如果包含未被允许更新的字段，会抛ForbiddenAttributesError错误
params 实际上是Parameter实例对象，我们可以对它的属性进行读、写操作

params == request.parameters # => true
并不表明它们是完全等价的 后者是ActiveSupport::HashWithIndifferentAccess实例对象
这个对象的值是什么？ 表单数据或传递过来的，加上:controller 和 :action

send_data send_file是类似的 但 send_data 可以发送的是数据 send_file 只能先有文件，才能发送
一般 动态生成的一次性内容 用send_data 比较好，纯文件或内容可提供多次下载的 用send_file 比较好
另外 实际项目里 静态资源还可以通过web服务器(Nginx/Apache)发送，应用只要提供URL即可。静态资源的URL
此时，仍然可以和原来一样调用send_file方法但真正返回数据的时候，web服务器会自动忽略掉应用服务器的response

config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
config.actino_dispatch.x_sendfile_header = "X-Accel-Redirect"
config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for Nginx
flash.alert = "you must be logged in"
flash.notice = "post successfully created"
flash.alert
flash.notice

add_flash_types :warning, :success, :danger

alert notice 默认已经使用add_flash_types

flash消息的生命周期可到下一个action 所以通常搭配redirect_to使用
flash.now[]消息的生命周期仅限于本action，所以 通常搭配render使用
helpers
本质是ActionView::Base的实例对象
ApplicationController.helpers.class
all_helpers_from_path
helper_attr
modules_for_helpers
config.action_controller.include_all_helpers = false
cookies 本质上是 request.cookie_jar

Middleware是Action Dispatch实现的，而Metal增强组件是Action Controller实现的
Middleware是在请求进入Controller#action之前，而Metal增强组件是在请求进入Controller#action之后
Middleware需要的环境是 @env 作用的是app， 而Metal增强组件需要的环境是Controller和action，目的主要是对请求做处理，并相应
action接受请求并处理，最后渲染相应视图模板或重定向到另一个action
如果你想在所有controller处理之前做一些什么，你可以把它们写在ApplicationController里
config.action_controller.perform_caching = false
config.action_controller.perform_caching = true

cache
write_fragment read_fragment
cache_store

cache 'all_available_products', skip_digest: true
expire_fragment('all_available_products')

default_form_builder
class AdminForBuilder < ActionView::Helpers::default_form_builder
	def special_field(name)

	end

end

module Rails
  class Engine < Railtie
    def routes
      @routes ||= ActionDispatch::Routing::RouteSet.new
      @routes.append(&Proc.new) if block_given?
      @routes
    end
  end
end
Rails.application.routes

Rails.application.routes.draw do
  # block 内容
end

def draw(&block)
  eval_block(block)

  nil
end

def eval_block(block)

  mapper = Mapper.new(self)

  mapper.instance_exec(&block)
end

module ActionDispatch
  module Routing
    class Mapper
      def initialize(set)
        @set = set
        @scope = Scope.new({ :path_names => @set.resources_path_name})
        @concerns = {}
        @nesting = []
      end
    end
  end
end

require 'bundler/setup'

run Proc.new{ |env|
    if env["PATH_INFO"] == "/"
      [200, {"Content-Type" => "text/html"}, []]
    else
      [404, {"Content-Type" => "text/html"},[]]
    end
    }

require 'bundler/setup'
require 'action_dispatch'

routes = ActionDispatch::Routing::RouteSet.new
routes.draw do
  get '/' => 'mainpage#index'
  get '/page/:id' => 'mainpage#show'
end

class MainpageController
  def self.action(method)
    controller = self.new
    controller.method
  end
  def index(env)
    [200, {"Content-Type" => "text/html"},[]]
  end
  def show(env)
    [200, {"Content-Type" => "text/html"},[]]
  end
end

run routes


routes = ActionDispatch::Routing::RouteSet.new
routes.draw do
  get '/' => 'mainpage#index'
end

class MainpageController < ActionController::Metal
  def index
    self.response_body = ""
  end
  def show
    self.status = 404
    self.response_body = ""
  end
end

include AbstractController::Rendering
include ActionController::Rendering
include ActionController::ImplicitRender
include ActionView::Rendering

def render_to_body(*args)
  template = ERB.new File.read("#{params[:action]}.html.erb")
  template.result(binding)
end

run routes

# config.ru
# require 'bundler/setup'
# require 'action_dispatch'
# require 'action_view'
require 'action_controller'
routes = ActionDispatch::Routing::RouteSet.new
routes.draw do
  get '/' => 'mainpage#index'
  get '/page/:id' => 'mainpage#show'
end
class MainpageController < ActionController::Base
  prepend_view_path('app/views/')
  def index
    @local_var = 12345
  end
  def show
  end
end
use ActionDispatch::DebugExceptions
run routes

rackup config.ru 运行以上代码，默认在 http://localhost:9292/


Middleware 在路由转发之后，Controller#action接收之前，对环境和应用进行处理。
路由转发-》 middleware -》 controller#action


app应用 --> (Rack) --> 应用服务器 --> Web服务器 --> 外部世界;

Rack 提供了一个与Web服务器打交道最精简的接口，通过这个接口，我们应用很轻松的就能提供Web服务(接收Web请求，相应处理结果)。
上面的应用服务器就是对Rack的进一步封装
这个接口的条件是： 传递一个程序(你没看错，就是把一个程序当做参数，下文以app代替)


class YourRack
  def initialize app
    @app = app
  end
  def call env
    @app.call(env)
  end
end

ActionController#cookies 读写cookies数据
简单的cookie数据
浏览器关闭则删除
cookies[:user_name] = "david"
设置cookie数据的生命周期为一小时
cookies[:login] = { value: "XJ-122", expires: 1.hour.from_now}
# cookie 数据签名(用到secrets.secret_key_base), 防止用户篡改
# 可以使用 cookies.signed[:name] 获取这个签名后的数据
cookies.signed[:user_id] = current_user.id
# 设置一个永久cookie，默认生命周期是20年
cookies.permanent[:login] = "XJ-122"
# 你可以链式调用以上方法

include ActionDispatch::Http::Cache::Request
include ActionDispatch::Http::MimeNegotiation
include ActionDispatch::Http::Parameters
include ActionDispatch::Http::FilterParameters
include ActionDispatch::Http::URL

env = { "Content-Type" => "text/html"}
headers = ActionDispatch::Http::Headers.new(env)
headers["Content-Type"]
request.parameters 和 params 是不同的,params还包括了 path_parameters

Rails.application.config.filter_parameters += [:password]
config.filter_redirect << 'www.rubyonrails.org'
Rails.application.config.filter_redirect << 'www.rubyonrails.org'

require 'action_dispatch'
routes = ActionDispatch::Routing::RouteSet.new
routes.draw do
  get '/' => 'mainpage#index'
  get '/page/:id' => 'mainpage#show'
end

include Rails.application.routes.url_helpers
include Rails.application.routes.url_helpers
include Rails.application.routes.url_helpers

Routing::RouteSet::Dispatcher.new(defaults)


#在 Controller 里，除了实例变量，我们还可以有其它方法传递内容给 View，两者方式类似。

class BasicController < ActionController::Base

  # 1 只引入对应模块
  include ActionView::Context

  # 2 调用对应模块里的方法
  before_filter :_prepare_context

  def hello_world
    @value = "Hello World"
  end

  protected
  # 3 更改 view_context
  # 默认是 ActionView::Base 的实例对象

  def view_context
    self
  end

  # 在view里可以调用此方法

  def __controller_method__
    "controller context!"
  end
end





























