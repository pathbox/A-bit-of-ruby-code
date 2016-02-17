module Lockable
  def self.included(base)
    base.include InstanceMethods
    base.class_eval do
      class_attribute :maximum_attempts, :unlock_in
      self.maximum_attempts = 5
      self.unlock_in = 30.minutes
    end
  end

  module InstanceMethods
    def lock_access!
      self.locked_at = TimeCalculator.current_time
      save(validate: false)
    end

    def unlock_access!
      self.locked_at = nil
      self.failed_attempts = 0
      save(validate: false)
    end

    def authenticate(unencrypted_password)
      if BCrypt::Password.new(password_digest).is_password?(unencrypted_password)
        unlock_access! if lock_expired?
        true
      else
        self.failed_attempts ||= 0
        self.failed_attempts += 1
        if attempts_exceeded?
          lock_access! unless access_locked?
        else
          save(validate: false)
        end
        false
      end
    end

    def access_locked?
      locked_at.present? && !lock_expired?
    end

    def last_attempt?
      self.failed_attempts == self.class.maximum_attempts - 1
    end

    def attempts_exceeded?
      self.failed_attempts >= self.class.maximum_attempts
    end

    def attempts_dirty?
      !access_locked? && self.failed_attempts > 0
    end

    protected
    def lock_expired?
      locked_at && locked_at < self.class.unlock_in.ago
    end
  end
end