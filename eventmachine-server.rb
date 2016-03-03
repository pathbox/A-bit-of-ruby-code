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


#这是怎么回事？好，我们定义了EchoServer模块实现echo协议的语法。最后3行调用的是event-machine自身，它将一直运行，除非你 在回调中终止它。
#在EveentMachine::run中包含的块是在event machine初始化之后以及开始轮询前执行的。在这里将根据指定的ip地址和端口打开一个TCP服务器并侦听，连同将处理数据的模块。
#那么EchoServer模块做什么用？好，每个网络连接启动时，EventMachine都会分配一个匿名类，你的模块将被混合进去。确切的说为每个连 接创建一个类实例。当一个连接的某个事件发生时，它会自动调用相应对象的实例方法，你可以在模块中重定义。
#在你的模块代码总是在一个类的实例的上下文中运 行，所以如果你希望，那么你可以创建实例变量，他们可以在同一个连接的其他回调中使用。
#提示:连接关闭(close_connection)时不终止进程轮询，你的服务器仍然可以接受连接。