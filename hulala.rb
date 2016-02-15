require 'rack'

Rack::Server.start

def self.start(options = nil)
  new(options).start
end

def initialize(options = nil)
  @options = options
  @app = options[:app] if options && options[:app]
end

Rack::Handler.default(options) wrapped_app

def initialize default_app = nil, default_app, nil
  @user, @map, @run = [], nil, default_app
  instance_eval &block if block_given?
end

def use middleware, *args, &block
end
def run app
  @run = app
end
def map path, &block
  @map ||= {}
  @map[path] = block
end

def initialize app
  @app = app
end

def call env
  @app.call env
end

def initialize app
  @app = app
end
def call env
  @app.call env
end

def initialize app
  @app = app
end

def call env
  @app.call env
end

def initialize app
  @app = app
end

def call env
  @app.call env
end

def initialize app
  @app = app
end
def call env
  @app.call env
end
def initialize app
  @app = app
end
def call env
  @app.call env
end
def initialize app
  @app = app
end
def call env
  @app.call env
end
use Mdw
use Mdw2
run startApp
call('env')




































