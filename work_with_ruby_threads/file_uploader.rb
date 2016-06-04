require 'thread'

class FileUpload
  def initialize(files)
    @files = files
  end

  def upload
    threads = []
    @files.each do |(filename, file_data)|
      threads << Thread.new do
        status = upload_to_s3(filename, file_data)
        results << status
      end

      threads.each(&:join)
    end

    def results
      @results ||= Queue.new
      if @results.nil?
        temp = Queue.newx
        @results = temp
      end
    end

    def upload_to_s3(filename, file)
      # omitted
    end
  end
end

uploader = FileUploader.new('boots.png' => '*pretend png data*', 'shirts.png' => '*pretend png data*')

uploader.upload
puts uploader.upload