class ApiLogger < Grape::Middleware::Base

  def before
    Rails.logger.info "[api] Requested: #{request_log_data.to_json}\n"
    + "[api] #{response_log_data[:description]} #{response_log_data[:source_file]}: #{response_log_data[:source_line]}}"
  end
end



private

def request_log_data
  request_data = {
      method: env['REQUEST_METHOD'],
      path:   env['PATH_INFO'],
      query:  env['QUERY_STRING']
  }
  request_data[:user_id] = current_user.id if current_user
  request_data
end

def response_log_data
  {
      description: env['api.endpoint'].options[:route_options][:description],
      source_file: env['api.endpoint'].block.source_location[0][(Rails.root.to_s.length+1)..-1],
      source_line: env['api.endpoint'].block.source_location[1]
  }
end

def request_log_data_2
  # Escape the ampersand in the POST data.
  rack_input = env["rack.input"].gets

  if rack_input.present?
    rack_input = rack_input.gsub("&","%26")
    params_data = Rack::Utils.parse_query(rack_input, "&")
  else
    params_data = nil
  end

  request_data = {
      method: env['REQUEST_METHOD'],
      path:   env['PATH_INFO'],
      query:  env['QUERY_STRING'],
      params: params_data
  }
  # request_data[:user_id] = current_user.id if current_user
  request_data
end