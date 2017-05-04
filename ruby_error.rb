module GemName

  class AuthenticationError < StandardError; end
  class InvalidUsername < AuthenticationError; end

end

raise Exceptions::InvalidUsername


# lib/app_name/error/base.rb

module AppName
    module Error
        class BadStuff < ::AppName::Error::Base; end
    end
end
