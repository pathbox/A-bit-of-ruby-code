scope :by_age, lambda do |age|
  joins(:profile).where('profile.age = ?', age) unless age.nil?
end

scope :by_status, ->{|status| where(status: status) unless status.blank?}
status = 1 ; User.by_status(status) # SELECT `users`.* FROM `users` WHERE `users`.`active` = 1
status = nil ; User.by_status(nil) # SELECT `users`.* FROM `users`

# you can understand something like ransack