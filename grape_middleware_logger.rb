gem 'grape', '>= 0.17'
gem 'grape-middleware-logger'

class API < Grape::API
  # use Grape::Middleware::Logger

  use Grape::Middleware::Logger, {
    logger: Rails.logger,
    filter: ActionDispatch::Http::ParameterFilter.new(Rails.application.config.filter_parameters)
  }
end
