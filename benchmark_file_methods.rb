require 'benchmark'

Benchmark.bm do |x|
  x.report("open each_line") do
    lines = 0
    1.times do
      File.open("/Users/path/work/log/development.log").each_line do
        lines += 1
      end
    end
    p "  #{lines}"
  end
  x.report("readlines each") do
    lines = 0
    1.times do
      File.readlines("/Users/path/work/log/development.log").each do
        lines += 1
      end
    end
    p "  #{lines}"
  end
  x.report("open") do
    1.times do
      File.open("/Users/path/work/log/development.log")
    end
  end
  x.report("readlines") do
    1.times do
      File.readlines("/Users/path/work/log/development.log")
    end
  end
end

# user     system      total        real
#open each_line"  8058686"
#3.960000   0.520000   4.480000 (  4.772198)
#readlines each"  8058686"
#7.260000   1.050000   8.310000 (  8.518303)
#open  0.000000   0.000000   0.000000 (  0.000037)
#readlines  7.210000   1.590000   8.800000 (  9.214043)

# So open is the best method.