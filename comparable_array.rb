class Array
  def <(other)
    (self <=> other) == -1
  end
  def <=(other)
    (self < other) or (self == other)
  end
  def >(other)
    (self <=> other) == 1
  end
  def >=(other)
    (self > other) or (self == other)
  end
end
