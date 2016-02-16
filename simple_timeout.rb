
require 'timeout'

begin
  timeout(0.1){
    sleep 0.2
  }
rescue TimeOut::Error => e
  puts e.message
end