class BenchmarkFilter
  def self.filter(controller)
    timer = Time.now
    Rails.logger.debug "---#{controller.controller_name} #{controller.action_name}"
    yield  # 這裡執行Action動作
    elapsed_time = Time.now - timer
    Rails.logger.debug "---#{controller.controller_name} #{controller.action_name} finished in %0.2f" % elapsed_time
  end
end

class EventsControler < ApplicationController
  around_action BenchmarkFilter
end

# around_action 可以加一个类，也可以加具体的方法

def save_notice
  log_id = SecureRandom.uuid

  request_options = {}
  request_options[:log_id]     = log_id
  request_options[:request_at] = Time.now
  request_options[:params]     = params.except(:action, :controller)
  YtxappInboxNoticeWorker.perform_async :ivr_request, request_options

  consuming = Benchmark.measure{ yield }.real

  response_options = {}
  response_options[:log_id]        = log_id
  response_options[:consuming]     = consuming
  response_options[:response_at]   = Time.now
  response_options[:response_body] = response.body
  YtxappInboxNoticeWorker.perform_in 20.seconds, :ivr_response, response_options
end

around_action :save_notice

# save_notice 方法中需要有yield，action就是回调执行在yield中