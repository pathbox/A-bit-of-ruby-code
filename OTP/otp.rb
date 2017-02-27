require 'hotp'


module Otp
  def totp(secret, digits = 6, step = 30, initial_time = 0)
    steps = (Time.now.to_i - initial_time) / step

    hotp(secret, steps, digits)
  end
end