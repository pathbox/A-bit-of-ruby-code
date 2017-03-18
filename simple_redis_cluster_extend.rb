class Redis
  attr_accessor :values
  def initialize(ip)
    @values = {}
  end

  def set(key, value)
    @values[key] = value
  end

  def get(key, value)
    @values[key]
  end
end

#虚拟节点
class VNode
  attr_accessor :node
  def execute(*params)
    node.execute(*params)
  end
end

#真实节点
class Node
  attr_accessor :vnodes, :ip, :redis
  def initialize(ip)
    @ip = ip
    @redis = Redis.new ip
    @vnodes = []
  end

  def execute(command, key, value)
    @redis.send(command, key, value)
  end
end

# 服务接口
class Server
  attr_accessor :nodes, :vnodes

  def initialize(ips)
    # 初始化2的16次方个虚拟节点
    @vnodes = (1<<16).times.map{VNode.new}
    @nodes = ips.map{|ip| Node.new(ip)}
    build_vnodes(:initialize)
  end

  def add_node(ip)
    @new_node = Node.new(ip)
    build_vnodes(:add)
  end

  def remove_node(ip)
    @removed_node = @nodes.delete(@nodes.select{|item| item.ip == ip}.shift)
    build_vnodes(:remove)
  end

  def execute(command, key, value = nil)
    @vnodes[key.hash % @vnodes.size].execute(command, key, value)
  end

  def build_vnodes(key)
    case key
    when :initialize
      @vnodes.each_with_index do |vnode, index|
        @nodes[index % @nodes.size].vnodes << vnode
        vnode.node = @nodes[index % @nodes.size]
      end
    when :add
      move_size = @vnodes.size / @nodes.size - @vnodes.size / (@nodes.size+1)
      @nodes.each do |node|
        @new_node.vnodes << node.vnodes.shift(move_size)
      end
      @new_node.vnodes.flatten!
      @new_node.vnodes.each{|vnode| vnode.node = @new_node}
      @nodes << @new_code
      @new_code = nil
    when :remove
      @remove_node.vnodes.each_with_index do |vnode, index|
        @nodes[index % @nodes.size].vnodes << vnode
        vnode.node = @nodes[index % @nodes.size]
      end
      @remove_node = nil
    end
  end
end

require 'securerandom'
keys = 10000.times.map { SecureRandom.uuid }
ips = ['127.0.0.1','127.0.0.2', '127.0.0.3' , '127.0.0.4']
@server = Server.new ips
keys.each {|key| @server.execute 'set',key, true }
result = @server.nodes.map {|node| node.redis.values.count}
p result
# 每个nodes上存储的key的数量
# => [2411, 2531, 2531, 2527]

@server.add_node '127.0.0.5'

count = 0
keys.each do |key|
  count+=1 if @server.execute 'get',key
end
puts count
# => 8068

# 基本上跟预测的一致 原有节点数/新的节点数 的命中率