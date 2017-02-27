filename = File.join(Rails.root, 'log', "study.log")
logger   = Logger.new(filename)  # 新建study.log 日志文件
logger.info "study" # 这条日志内容会写入study.log

# 当前日志级别

Rails.logger.level

config.log_level = :warn

Rails.logger.info "example"
Rails.logger.warn "example"

logger = Rails.logger
logger.tagged("pathbox") { logger.warn "I am pathbox"}
# [pathbox] I am pathbox

logger.tagged("Curry", "Jerry") { logger.info "hello world"}
# [Curry] [Jerry] hello world

