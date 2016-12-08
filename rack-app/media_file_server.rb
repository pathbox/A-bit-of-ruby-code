class MediaFileServer < Rack::App
  serve_files_from '/folder/from/project/root', to: '/files'

  get '/' do
    serve_file 'custom_file_path_to_stream_back'
  end
end
