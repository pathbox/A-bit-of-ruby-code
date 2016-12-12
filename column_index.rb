def column_index_hash
  column_index = Hashie::Mash.new
  @head_data.each_with_index do |data, index|
    case data
    when data == "工单标题"
      column_index.subect = index
    when data == "工单描述"
      column_index.content = index
    when data == "客户邮箱"
      column_index.c_email = index
    when data == "客户手机"
      column_index.c_cellphone = index
    when data == "状态"
      column_index.status = index
    when data == "优先级"
      column_index.priority = index
    when data == "受理客服组"
      column_index.group = index
    when data == "受理客服"
      column_index.agent = index
    when data == "标签"
      column_index.tag = index
    when data == "关注者"
      column_index.follower = index
    when data == "工单模板"
      column_index.template = index
    end
  end
  column_index
end

@index = column_index_hash

def custom_column_index_hash
  i = @index.template
  template_name = row[i]
  custom_fields_hash = custom_fields_hash(template_name)

end
