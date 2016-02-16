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








































