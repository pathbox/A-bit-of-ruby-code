require 'logger'

# log = Logger.new(STDOUT)
log = Logger.new('./a_log.log')
log.level = :info
log.progname = 'LOG'

log.debug('This is debug')
log.info('This is info')
log.info({name: 'kitty', age: 20, info: 'hello kitty'})
