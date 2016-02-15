#检测表达式中欧你不配对的标点
def paren_match(str)
  stack = [] #Stack.new 数组数据结构 构造栈结构
  lsym = "{[(<" #构造所有左括号
  rsym = "}])>" #构造所有右括号
  str.each_byte do |byte|
    sym = byte.chr
    if lsym.include? sym
      stack.push(sym)
    elsif rysm.include? sym
      top = stack.last
      if lsym.index(top) != rsym.index(sym)
        return false
      else
        stack.pop
      end
    end
  end
  return stack.empty? #empty 说明匹配成功
end
