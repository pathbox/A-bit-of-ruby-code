gem 'sidekiq_mailer'

class MyMailer < ActionMailer::Base
  include Sidekiq::Mailer

  def welcome(to)
  end
end

MyMailer.welcome('your@email.com').deliver

# The default queue used by Sidekiq::Mailer is 'mailer'. So, in order to send mails with sidekiq you need to start a worker using:

# sidekiq -q mailer

# If you want to skip sidekiq you should use the 'deliver!' method

# Mail will skip sidekiq and will be sent synchronously
MyMailer.welcome('your@email.com').deliver!


