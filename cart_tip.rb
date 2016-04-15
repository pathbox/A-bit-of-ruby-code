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