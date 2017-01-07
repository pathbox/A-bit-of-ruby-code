# 一种使用around_action 的方式得到action执行耗时的方法

class UsersController < ActionController::Base

  around_action :bench_mark, only: :index

  def index
    render json: {code: 200, message: "Hello World!"}
  end

  private

  def bench_mark
    options = Hash.new
    options[:begin_at] = Time.now.to_s

    exception = nil
    consuming = Benchmark.measure do
      begin
        yield
      rescue => e
        exception = e
      end
    end

    options[:end_at] = Time.now.to_s
    options[:consuming] = consuming
    options[:exception] = exception

    MarkRecordLog.create! options
  end

end