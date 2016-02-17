def self.cached_tag_cloud
  APP_CACHE.fetch("#{CACHE_PREFIX}/blog_tags/tag_cloud") do
    self.tag_counts.sort_by(&:count).reverse
  end
end

def increment_view_count
  increment
end

def show
  @topic = Topic.find params[:id]
  user_session.update if logged_in?
  Topic.increment_counter()
  @posts = @topic.post_by_page params[:page]
  posts_hash = @posts.map{|p| {p.id=>p.updated_at}}.hash
  topic_hash = @topic.form_id + @topic.sys_tag_id.to_i + @topic.title.hash + @topic.status_flag.hash
  if logged_in? || stale?(etag: [posts_hash, topic_hash])
    render
  end
end

class Class
  def attr_accessor(*attrs)
    attrs.each do |attr|
      define_method attr do
        instance_variable_get "@#{attr}"
      end
      define_method "#{attr}=" do |attr|
        instance_variable_set "@#{attr}", val
      end
    end
  end
end

class << foo
  def singleton_func
    self
  end
end

def foo.singleton_func
  self
end
class Object
  def eigrnclass
    class << self
      self
    end
  end
end


def blah(options)
  puts options[:foo]
  puts options[:bar]
end

blah(:foo => "test", :bar => "test")
def sum(*args)
  puts args[0]
  puts args[1]
  puts args[2]
end
sum(1,2,3)

def link_to(*args, &block)
  if block_given?
    options = args.first || {}
    html_options = args.second
    link_to(capture(&block), options,options, html_options)
  else
    name = args[0]
    options = args[1] || {}
    html_options = args[2]
    html_options = convert_options_to_data_attributes(options,html_options)
    url = url_for(options)
  end
end

def foobar(*args)
  optoins = args.extract_options!
end

foobar(1,2)
# options is {}
foobar(1,2, :a => :b)

def call_block
  puts "start"
  yield("foobar") if block_given?
  puts "end"
end
call_block do |str|
  puts "here"
  puts str
  puts "here"
end

# 同步、异步
# 比如我去银行办理业务，可以自己去排队办理，也可以叫人代办，等他帮我处理完了直接给我结果，对于要办理这个银行业务的人而言，自己去办理时同步方式，而别人代办则是异步方式
# 区别在于，同步的方式下，操作者主动完成了这件事。异步方式下，调用指令发出之后，操作马上就返回了，操作者不能马上就知道结果，而是等待调用的异步过程（这里就是帮忙代办的人）
# 处理完毕之后，通过通知手段（在代码中通常是回调函数）来告诉操作者结果。

# 阻塞、非阻塞
# 这两个概念与程序处理事务时的状态有关
#同样是前面的例子，当真正执行办理业务的人去办理银行业务时，前面可能已经有人排队等候了。如果这个人一直从排队到处理完毕，中间都没有做过其他的事情，那么这个过程就是阻塞的，这个人当前就只在做这么一件事情。
#反之，如果这个人发现前面排队的人不少，于是选择了出去逛逛，过了一会再回来看看有没有轮到自己的号，如果没有又继续出去逛过一阵再回来看看，如此以往，这个过程就是非阻塞的，因为处理这个事情的人
# 在整个过程中，并没有做到除了这件事之外不能做别的事情，他的做法是反复的过来尝试，如果没有完成就下一次再尝试完成这件事情。

# 非阻塞IO。 当没有数据可读时，同样的recvfrom操作返回了错误码，表示当前没有可读数据，换言之，即使没有数据也不会一直让这个应用阻塞在这个调用上

# conclusion  阻塞/非阻塞  区别在于完成一件事情，是不是当事情还没有完成时，处理这件事情的人除此之外不能再做别的事情。（只有一个人，可以做不只一件事情）
# 同步/异步  是自己去做这件事情，还是等别人做好了来通知你，然后自己去拿结果（只有一件事情。可以两个人在做）只要是自己去完成的都是同步

# 同步+阻塞 一个人只完成一件事情
# 同步+非阻塞 一个人可以完成多件事情
# 异步+阻塞 不只一个人，完成一件事情
# 异步+非阻塞 不只一个人，完成多件事情













































