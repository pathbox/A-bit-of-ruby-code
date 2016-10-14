class Product < ActiveRecord::Base
  scope :status, -> (status) { where status: status }
  scope :location, -> (location_id) { where location_id: location_id }
  scope :starts_with, -> (name) { where("name like ?", "#{name}%")}
end

def index
  @products = Product.where(nil) # creates an anonymous scope
  @products = @products.status(params[:status]) if params[:status].present?
  @products = @products.location(params[:location]) if params[:location].present?
  @products = @products.starts_with(params[:starts_with]) if params[:starts_with].present?
end
