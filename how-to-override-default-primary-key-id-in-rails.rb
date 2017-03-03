class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products, id: false do |t|
      t.string :sku, null: false

      t.timestamps
    end

    execute %Q{ ALTER TABLE "products" ADD PRIMARY KEY ("sku"); }
  end
end

class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products, id: false do |t|
      t.string :sku, null: false

      t.timestamps
    end

    add_index :products, :sku, unique: true
  end
end

class Product < ActiveRecord::Base
  self.primary_key = 'sku'
end

# File activerecord/lib/active_record/connection_adapters/abstract/schema_definitions.rb, line 68
def primary_key(name, type = :primary_key, options = {})
  column(name, type, options.merge(:primary_key => true))
end

# File activerecord/lib/active_record/attribute_methods/primary_key.rb, line 17
# def id
#   sync_with_transaction_state
#   read_attribute(self.class.primary_key)
# end

# the read_attribute(self.class.primary_key) line tells us that it will reference to our Product.primary_key, that is sku. Therefore, we you call:
#
# Product.find('SKU-01')
# SELECT  "products".* FROM "products"  WHERE "products"."sku" = $1 LIMIT 1  [["sku", 'SKU-01']]

# With Rails 4, you can change :id to :sku with:

# config/routes.rb
resources :products, param: :sku
# bundle exec rake routes
# Prefix Verb  URI Pattern                       Controller#Action
# products GET   /products(.:format)              products#index
#                    POST   /products(.:format)              products#create
# new_product GET   /products/new(.:format)          products#new
# edit_product GET   /products/:sku/edit(.:format)    products#edit
# product GET   /products/:sku(.:format)         products#show
# PATCH   /products/:sku(.:format)         products#update
# PUT   /products/:sku(.:format)         products#update
# DELETE   /products/:sku(.:format)         products#destroy

# http://0.0.0.0:3000/products/SKU%23001
# class Product < ActiveRecord::Base
# ...
#     def to_param
#       sku.parameterize
#     end
# ...
# end
# and the URI turns to:
# http://0.0.0.0:3000/products/SKU-001
#
# Adding NOT NULL and UNIQUE contrainst to column you want to be the primary key
# Set self.primary_key for the model
# Set param for your routing
# Override #to_param for friendly URI
