# 将树型存储结构 平铺输出为 一条条 item 为了 csv导出

op = [{"title"=>"北京市", "value"=>"0", "subs"=>[{"title"=>"海淀区", "value"=>"0", "subs"=>[{"title"=>"知春路", "value"=>"0"}]}]}, {"title"=>"天津市", "value"=>"1", "subs"=>[{"title"=>"和平区", "value"=>"0"}]}]
# the value is key

def loo(op, key='')
  op.index do |item|
    if key.present?  # key 是parent 的key，是外层的key
      mkey = key + '_' + item["value"]
    else
      mkey = item["value"]
    end
      out = { mkey => item["title"] }
      puts out
    if item["subs"].present?
      loo(item["subs"], mkey)
    end
  end
end

# =>
# {"0"=>"西甲"}
# {"0_0"=>"皇家马德里"}
# {"1_0"=>"巴塞罗那"}
# {"2_0"=>"马德里竞技"}
# {"1"=>"英超"}
# {"0_1"=>"曼城"}
# {"1_1"=>"阿森纳"}
# {"2_1"=>"切尔西"}
# {"3_1"=>"利物浦"}
# {"2"=>"意甲"}
# {"0_2"=>"尤文图斯"}
# {"1_2"=>"罗马"}
# {"3"=>"法甲"}
# {"0_3"=>"大巴黎"}
# {"1_3"=>"摩纳哥"}
