def turn_distribute(ary = [])
  # 优先使用assign_id 可以防止队列中增加成员的影响
  # 如果assign_id 在队列中找不到了，使用assign_index得到分配人
  # 当下一次的索引值大于队列的count值时，可能会导致在前头的人被跳过
  user_ids = ary
  user_group = UserGroup.first
  return nil if user_ids.blank?

  assignee_id = nil
  user_group.with_lock do
    find_index = user_ids.find_index(user_group.assign_id)
    if find_index
      index = find_index % user_ids.count
    else
      index       = user_group.assign_index % user_ids.count
    end
    assignee_id = user_ids[index]
    new_index   = (assignee_id.blank? || assignee_id == user_ids.last) ? 0 : index + 1
    new_id = user_ids[new_index]
    user_group.update!(assign_index: new_index, assign_id: new_id)
  end

  return assignee_id
end
