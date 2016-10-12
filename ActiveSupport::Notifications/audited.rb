# lib/audited.rb

module Audited
  extend ActiveSupport::Concern

  included do
    after_save :audit
  end

  def audit_data
    if respond_to? :attributes
      self.attributes
    else
      fail "No audit data available for #{self.class.name}. Please add an #audit_data method and return a hash of data from it."
    end
  end

  def audit
    event_name = "Save #{self.class.name.split("::").last}"
    ActiveSupport::Notifications.instrument :audit, :event_name => event_name, :current_user => Thread.current[:user], :audited_object => self
  end
end

# app/models/medication.rb
# class Medication < ActiveRecord::Base
#   include Audited
# end
