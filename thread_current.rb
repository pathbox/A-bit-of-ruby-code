module ThreadCurrent

  def current_user
    Thread.current[:current_user]
  end

  def current_user=(value)
    Thread.current[:current_user] = value
  end

  def set_current_user(value)
    self.current_user = value
  end

  def clear_current_user
    self.current_user = nil
  end
end