require 'rubygems'
require 'ruby-prof'
require 'benchmark'

exit(0) unless ARGV[0]

GC.enable_stats
RubyProf.measure_mode = RubyProf.const_get(ARGV[0])

result = RubyProf.profile do
  str = 'x' * 1024*1024*10
  str.upcase
end

printer = RubyProf::FlatPrinter.new(result)
printer.print(File.open("#{ARGV[0]}_profile.txt", "w+"), min_percent: 1)
printer = RubyProf::CallTreePrinter.new(result)
printer.print(File.open("callgrind.out.memprof_app", "w+"))

# ruby memprof_app.rb MEMORY
# ruby memprof_app.rb ALLOCATIONS
# measurement1 = `ps -o rss= -p #{Process.pid}`.to_i/1024