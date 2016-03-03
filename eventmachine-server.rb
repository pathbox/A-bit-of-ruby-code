require 'rubygems'
require 'eventmachine'

class Echo < EM::Connection
  def receive_data(data)
    send_data(data)
  end
end
EM.epoll  # EM 默认使用select。这里使用 epoll, 比select更高效
EM.run do
  EM.start_server("0.0.0.0", 10001, Echo)
end

# ruby eventmachine-server.rb
# 在另一个窗口 telnet localhost 10000

# 仔细看一下上面的程式：EM帮我们启动了一个server，监听端口10000，而Echo实例（继承了Connection，用来处理连接）则重写了receive_data方法来实现服务逻辑。
# 而EM.run实际上就是启动了Reactor，它会一直运行下去直到stop被调用之后EM#run之后的代码才会被执行到。Echo类的实例实际上是与一个File Descriptor注册在了一起
# （Linux把一切设备都视作文件，包括socket），一旦该fd上有事件发生，Echo的实例就会被调用来处理相应事件

#在CloudFoundry中，组件的启动大多是从EM.run开始的，并且出于在多路复用I/O操作时提高效率和资源利用率的考虑，CF组件往往会在EM.run之前先调用EM.epoll （EM默认使用的select调用），比如：
#[ruby] view plain copy print?在CODE上查看代码片派生到我的代码片
#EM.epoll
# EventMachine中有一个最基本原则我们必须记住：Never block the Reactor!

# 当你的工作推迟或者阻塞在socket上，Reactor循环将继续处理其他的请求。当Deferred的工作完成之后，产生一个成功的信息并由reactor返回响应。