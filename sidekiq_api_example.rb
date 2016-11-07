require 'sidekiq/api'

class SidekiqQueuesController < ApplicationController
  skip_before_action :require_authentication

  def index
    base_stats = Sidekiq::Stats.new
    stats = {
       enqueued: base_stats.enqueued,
       queues: base_stats.queues,
       busy: Sidekiq::Workers.new.size,
       retries: base_stats.retry_size
    }

    render json: stats
  end
end

Sidekiq::Queue.all

Sidekiq::Queue.new # the "default" queue
Sidekiq::Queue.new("mailer")

Sidekiq::Queue.new.size  # job number
Sidekiq::Queue.new.clear

queue = Sidekiq::Queue.new("mailer")
queue.each do |job|
	job.klass # 'MyWorker'
	job.args  # [1,2,3]
	job.delete if job.jid == 'abcdefg123456'
end

# Calculate the latency (in seconds) of a queue (now - when the oldest job was enqueued):
Sidekiq::Queue.new.latency # 14.5

ss = Sidekiq::ScheduledSet.new
ss.size
ss.clear

r = Sidekiq::ScheduledSet.new
jobs = r.select { |retri| retri.klass == 'SomeWorker' }
jobs.each(&:delete)


rs = Sidekiq::RetrySet.new
rs.size
rs.clear

query = Sidekiq::RetrySet.new
query.select do |job|
  job.klass == 'Sidekiq::Extensions::DelayedClass' &&
    # For Sidekiq::Extensions (e.g., Foo.delay.bar(*args)),
    # the context is serialized to YAML, and must
    # be deserialized to get to the original args
    ((klass, method, args) = YAML.load(job.args[0])) &&
    klass == User &&
    method == :setup_new_subscriber
end.map(&:delete)

ds = Sidekiq::DeadSet.new
ds.size
ds.clear

ps = Sidekiq::ProcessSet.new
ps.size
ps.each do |process|
	p process['busy']  # 3
	p process['hostname']  # myhost.local
	p process['pid']  #  16131
end
ps.each(&:quiet!)
ps.each(&:stop!)

workers = Sidekiq::Workers.new
workers.size # => 2
workers.each do |process_id, thread_id, work|
  # process_id is a unique identifier per Sidekiq process
  # thread_id is a unique identifier per thread
  # work is a Hash which looks like:
  # { 'queue' => name, 'run_at' => timestamp, 'payload' => msg }
  # run_at is an epoch Integer.
  # payload is a Hash which looks like:
  # { 'retry' => true,
  #   'queue' => 'default',
  #   'class' => 'Redacted',
  #   'args' => [1, 2, 'foo'],
  #   'jid' => '80b1e7e46381a20c0c567285',
  #   'enqueued_at' => 1427811033.2067106 }
end

stats = Sidekiq::Stats.new
stats.processed # => 100
stats.failed # => 3
stats.queues # => { "default" => 1001, "email" => 50 }

s = Sidekiq::Stats::History.new(2) # Indicates how many days of data you want starting from today (UTC)
s.failed # => { "2012-12-05" => 120, "2012-12-04" => 234 }
s.processed # => { "2012-12-05" => 1010, "2012-12-04" => 1500 }



























