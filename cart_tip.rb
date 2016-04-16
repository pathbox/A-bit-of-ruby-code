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
