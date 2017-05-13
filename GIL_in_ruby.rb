require 'benchmark'

@threads = []
Benchmark.bm(14) do |x|
  x.report('single-thread') do
    8.times do
      tmp_array = []
      10_000_000.times { |n| tmp_array << n }
    end
  end

  x.report('multi-thread') do
    8.times do
      @threads << Thread.new do
        tmp_array = []
        10_000_000.times { |n| tmp_array << n }
      end
    end
    @threads.each(&:join)
  end
end
#
# ```
#      user     system      total        real
# single-thread
#   5.240000   0.580000   5.820000 (  5.880398)
# multi-thread
#   6.450000   0.710000   7.160000 (  7.234476)
#
# ```

require 'faraday'

@conn = Faraday.new(url: 'https://ruby-china.org')
@threads = []

Benchmark.bm(14) do |x|
  x.report('single-thread') do
    20.times { @conn.get }
  end

  x.report('multi-thread') do
    20.times do
      @threads << Thread.new { @conn.get }
    end
    @threads.each(&:join)
  end
end

#    user     system      total        real
# single-thread
#   0.190000   0.020000   0.210000 (  4.345562)
# multi-thread     0.090000   0.020000   0.110000 (  0.269009)
