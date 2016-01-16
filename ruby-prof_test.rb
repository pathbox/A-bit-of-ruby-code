# 这是一种运行 ruby-prof 的方式 在源码中插入 ruby-prof 的启动和停止代码
# 第二种是 使用 命令  ruby-prof -p xxx filename.rb
#  ruby-prof -p graph_html rprofile_test.rb -f dot.html 这句命令将产生 dot.html 文件，分析内容都在里面。 同样的可以保存为 txt dot 等文件格式
#
# xxx: 
#flat                   - Prints a flat profile as text (default).
#flat_with_line_numbers - same as flat, with line numbers.
#graph                  - Prints a graph profile as text.
#graph_html             - Prints a graph profile as html.
#call_tree              - format for KCacheGrind
#call_stack             - prints a HTML visualization of the call tree
#dot                    - Prints a graph profile as a dot file
#multi                  - Creates several reports in output directory
require 'ruby-prof'

RubyProf.start

# 这里写入要进行性能剖析的代码

def m1
    "string" * 1000
end

def m2
    "string" * 10000
end

def start
    n = 0
      n = n + 1 while n < 100_000

        10000.times do
              m1
                  m2
                    end
end

start

result = RubyProf.stop

# 选择一个Printer
#
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)

#执行命令  ruby filename.rb
#
#解释说明
#%self方法本身执行的时间占比，不包括调用的其他的方法执行时间
#total方法执行的总时间，包括调用的其他方法的执行时间
#self方法本身执行的时间，不包括调用的其他的方法执行时间
#wait多线程中，等待其他线程的时间，在单线程程序中，始终为0
#child方法调用的其他方法的总时间
#calls方法的调用次数
#
#
#
#
#
#
