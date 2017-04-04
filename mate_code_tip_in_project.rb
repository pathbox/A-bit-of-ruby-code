(4.months + 5.years).from_now

# *_action is the same as append_*_action
alias_method :"append_#{callback}_action", :"#{callback}_action"

define_method "append_#{callback}_fillter" do |*names, &blk|
  ActiveSupport::Deprecation.warn("append_#{callback}_filter is deprecated and will be removed in Rails 5.1. Use append_#{callback}_action instead.")
  send("append_#{callback}_action", *names, &blk)
end

if RUBY_VERSION > "..."
  do something
end

%w(info debug warn error fatal unknown).each do |level|
  class_eval <<-METHOD, __FILE__, __LIKE__ + 1
  def #{level} (progname = nil, &block)
    logger.#{level}(progname, &block) if logger
  end
  METHOD
end

def helper_method(*meths)
  meths.flatten!
  self._helper_methods += meths

  meths.each do |meth|
    _helpers.class_eval <<-ruby_eval, __FILE__, __LINE__ + 1
    def #{meth}(*args, &blk)
      controller.send(#{meth}, *args, &blk)
    end
    ruby_eval
  end
end
