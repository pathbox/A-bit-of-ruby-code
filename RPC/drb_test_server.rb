require 'drb'

class DrbTestServer
  def add(*args)
    args.inject{|s, v| s + v}
  end
end

server = DrbTestServer.new
DRb.start_service('druby://localhost:9000', server)
DRb.thread.join