#user 和　role 变为多对多。使用次方法得到所有agent_role中的权限集合
def user_role_permissions # 错误的写法，如果有多个权限，后面的权限会覆盖前面的相同key的权限的值，使得最后的值不正确
  roles = self.agent_roles
  return {} unless agent_roles
  h = roles.each.inject({}) do |sum, agent_role|
    sum.merge!(agent_role.permission).merge!(agent_role.permissions)
  end
end

def user_role_permissions # 修复。通过循环，判断key是否存在并且key是否为true，是的话保持true值不变，不是的话使用后来的值
  roles = self.agent_roles
  return {} unless roles
  hash = Hashie::Mash.new
  roles.each do |role|
    role.permissions.each_pair do |key, value|
      if hash.key?(key)
        hash[key] = hash[key] ? true : value
      else
        hash[key] = value
      end
    end
    role.permission.each_pair do |key, value|
      if hash.key?(key)
        hash[key] = hash[key] == '1' ? true : value
      else
        hash[key] = value
      end
    end
  end
  hash
end