require 'fileutils'

class Uploader < Rack::App
  post '/to_stream' do
    payload_stream do |string_chunk|
      # do some work
    end
  end

  post '/upload_file' do
    file_path = Rack::App::Utils.pwd('/upliads', params['user_id'], params['file_name'])
    FileUtils.mkdir_p(file_path)
    payload_to_file(file_path)
  end

  post '/memory_buffered_payload' do
    payload  #> request payload string
  end
end