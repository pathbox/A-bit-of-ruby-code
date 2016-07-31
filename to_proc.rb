class Symbol
  def to_proc
    Proc.new {|x| x.send(self)}
  end
end

names = ['bob','bill']
p names.map(&:capitalize)

p [1,2,3].inject(0, &:+)