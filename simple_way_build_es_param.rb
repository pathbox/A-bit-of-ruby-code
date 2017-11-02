class ESParamsDsl
  def initialize
    @hash = {}
  end

# 使用method_missing 方法的灵活性
  def method_missing method_name, key=nil, value=nil, &block
    if block_given?
      new_instance = self.class.new # ESParamsDsl.new
      new_instance.instance_eval(&block)  # 执行block中的逻辑，由于block中也触发method_missing方法，所以这里形成了递归
      @hash[method_name] = new_instance.to_params # to_params 方法中的@hash和外面的@hash不是同一个
    else                                  # 递归结束条件就是 不再是block块代码
      @hash[method_name] ||= {}
      @hash[method_name][key] = value    # 返回最里层的 hash结构
    end
  end

  def to_params  # 返回当前的hash结构， 方法中的@hash和外面的@hash不是同一个
    @hash
  end
end

es_params = ESParamsDsl.new

es_params.bool do
  must do
    match 'title', 'test'
    term 'age', 27
  end
end

puts es_params.to_params

# 每一个block 就是一个hash结构