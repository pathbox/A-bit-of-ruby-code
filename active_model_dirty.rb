class Person

  include ActiveModel::Dirty

  define_attribute_methods :name

  def name
    @name
  end

  def name=(val)
    name_will_change! unless val == @name
    @name = val
  end

  def save
    # do persistence work
    changes_applied
  end

  def reload!
    # get the values from the persistence layer
    clear_changes_information
  end

  def rollback!
    restore_attributes
  end
end