# 将树型存储结构 平铺输出为 一条条 item 为了 csv导出

op = [{"title"=>"北京市", "value"=>"0", "subs"=>[{"title"=>"海淀区", "value"=>"0", "subs"=>[{"title"=>"知春路", "value"=>"0"}]}]}, {"title"=>"天津市", "value"=>"1", "subs"=>[{"title"=>"和平区", "value"=>"0"}]}]

def la(op)
  k = "chained_3c4a8ea8010927363414682eb9b82434"
  op.each_with_index do |option|
    key = k + "(#{option["value"]}|)"

    p [key, option["title"]]

    if option['subs'].present?
      lo(option['subs'], key)
    end
  end
end

def lo(op, key)
  op.each do |option|
    key.match(/\A.*\((\S+)\).*\Z/)
    r = $1
    pk = r.split("|").first
    mk = pk + "." + option["value"]
    ok = key.split("(").first

    key = ok + "(#{mk}|#{pk})"

    p [key, option["title"]]

    if option['subs'].present?
      op = option["subs"]
      lo(op, key)
    end
  end
end

la(op)
#
# =>
# ["chained_3c4a8ea8010927363414682eb9b82434(0|)", "北京市"]
# ["chained_3c4a8ea8010927363414682eb9b82434(0.0|0)", "海淀区"]
# ["chained_3c4a8ea8010927363414682eb9b82434(0.0.0|0.0)", "知春路"]
# ["chained_3c4a8ea8010927363414682eb9b82434(1|)", "天津市"]
# ["chained_3c4a8ea8010927363414682eb9b82434(1.0|1)", "和平区"]


key  parent_key

chained_droplist3c4a8ea8010927363414682eb9b82434 => [{"title"=>"北京市", "value"=>"0", "subs"=>[{"title"=>"海淀区", "value"=>"0", "subs"=>[{"title"=>"知春路", "value"=>"0"}]}]}, {"title"=>"天津市", "value"=>"1", "subs"=>[{"title"=>"和平区", "value"=>"0"}]}]

[{"title" => "北京市"}]

{
  chained_3c4a8ea8010927363414682eb9b82434 => [
    "option.1"=> {"option.1.0" => {},
                  "options.1.1" => {}
                  }
    "option.2"=>

  ],

}
