class ObjectTree

  def initialize
    @sub_tasks = []
  end
  
  def task
    total = 0
    @sub_tasks.each {|task| total += task.task}
    total
  end
end