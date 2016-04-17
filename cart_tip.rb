# cart.rb

def total_items
  line_items.sum(:quantity)
end

def total_price
  line_items.to_a.sum {|item| item.total_price}
end

#line_item.rb

def total_price
  product.price * quantity
end

# application_controller.rb

class ApplicationController < ActionController::Base
  before_action :authorize
  protect_from_forgery



  private

  def current_cart
    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    session[:cart_id] = cart.id
    cart
  end

  def current_user
  end
end



  protected

  def authorize
    unless User.find_by(id: session[:user_id])
      redirect_to login_path, notice: "Please log in"
    end
  end
end

#store_controller.rb

class StoreController < ApplicationController
  skip_before_action :authorize
end

# sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :authorize
end

class LineItemsController < ApplicationController
  skip_before_action :authorize, only: :create
end

class OrdersController < ApplicationController
  skip_before_action :authorize, only: [:new,:create]
end

#config/application.rb
#开启lib目录,让ｒａｉｌｓ加载ｌｉｂ中的代码.其中的代码(库代码)可以在MVC三个地方共享
config.autoload_paths += %W(#{Rails.root}/lib)
#如果一个库不能满足加载条件，可以使用ｒｅｑｕｉｒｅ机制。比如要加载lib/hello.rb文件，可以在任意MVC三个地方的文件开头，require "hello"。子目录下要加子目录的路径
require "shipping/arimail"  # lib/shipping/arimail.rb


Account.transaction do
  ac = Account.where(id: id).lock("LOCK IN SHARE MODE").first
  ac.balance -= amount if ac.balance > amount
  ac.save
end

class Order < ActiveRecord::Base
  scope :last_days, ->{ |days| where('updated< ?', days) }
  scope :checks, where(pay_type: :check)
end
#使用find_by_sql效率其实是更高的

def add_comment
  @article = Article.find(params[:id])
  comment = Comment.new(params[:comment])
  @article.comments << comment
  @article.save
end

#使用签名ｃｏｏｋｉｅｓ　这样只能得到自己的ｃｏｏｋｉｅｓ，无法通过浏览器修改得到别人的ｃｏｏｋｉｅｓ

#关键信息在ｃｏｏｋｉｅｓ中保存后要尽可能存数据库，防止ｃｏｏｋｉｅｓ丢失或删除