class Measure

  def self.run(options = {gc: :enable})
    if options[:gc] == :disable
      GC.disable
    elsif options[:gc] == :enable
      GC.start
    end
    memory_before = `ps -o rss= -p #{Process.pid}`.to_i/1024
    gc_stat_before = GC.stat
    time = Benchmark.realtime do
      yield
    end

    gc_stat_after = GC.stat
    GC.start if options[:gc] == :enable
    memory_after = `ps -o rss= -p #{Process.pid}`.to_i/1024

    puts ({
        RUBY_VERSION => {
          gc: options[:gc],
          time: time.round(2),
          gc_count: gc_stat_after[:count].to_i - gc_stat_before[:count].to_i,
          memory: "%d MB" % (memory_after - memory_before)
        }
      }.to_json
    )
  end
end