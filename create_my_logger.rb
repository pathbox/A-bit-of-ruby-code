module MyLogger

  def do_log
    log = {}
    title = []

    yield title, log

    timestamp  = Time.now.strftime('%Y%m%d_%H%M%S_%L')
    title      = [timestamp, title].flatten.compact
    title_text = title.join('-')

    data = {}
    data[:title] = title_text
    data.merge!(log)

    self.debug data.to_json
  end
end

def create_my_logger(file_name)
  logger = Logger.new("#{Rails.root}/log/#{file_name}")
  logger.level = Logger::DEBUG
  logger.formatter = proc do |serverity, datetime, progname, message|
    "#{datetime} #{serverity} #{progname} #{message}\n"
  end

  logger.extend MyLogger
  return logger
end

# use action
DETAIL_LOGGER = create_my_logger('detail.log')

DETAIL_LOGGER.do_log do |title, log|
  title << "请求"
  title << _id
  title << "title"

  log[:body]   = request_args
  log[:userid] = user_id
end