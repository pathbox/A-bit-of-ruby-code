class ProductsController < ApplicationController

  def show
    @product = Product.find(params[:id])
    if stale?(last_modified: @product.updated_at.utc, etg: @product.cache_key)
      respond_to do |wants|

      end
    end
    # respond_with(@product) if stale?(@product) 如果不想使用 Hash，还可直接传入模型实例，Rails 会调用 updated_at 和 cache_key 方法分别设置 last_modified 和 etag
  end

  def other_show
    @product = Product.find(params[:id])
    fresh_when last_modified: @product.published_at.utc, etg: @product
  end
end