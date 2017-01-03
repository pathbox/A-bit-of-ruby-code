class Hash
  # Dig a value of hash, by a series of keys
  #
  # info = {
  #          order: {
  #           customer: {
  #             name:  "Tom",
  #             email: "tom@mail.com"
  #             },
  #           total: 100
  #           }
  #        }
  #
  # puts info.dig :order, :customer
  # # => {name: "Tom", email: "tom@mail.com"}
  #
  # puts info.dig :order, :customer, :name
  # # => "Tom"

  def dig(*keys)
    keys.flatten!

    raise if keys.empty?
    current_key = keys.shift
    current_value = self.[](current_key)

    if keys.size == 0
      return current_value
    end

    if current_value.is_a?(Hash)
      return current_value.dig(keys)
    else
      return nil
    end
  end
end 