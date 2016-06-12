require 'date'
# require 'rubygems'
# require 'ruby-prof'

GC.disable
# RubyProf.start
# Date.parse("2016-06-09")
# result = RubyProf.stop

# result = RubyProf.profile do
#   Date.parse("2014-07-01")
# end

# printer = RubyProf::FlatPrinter.new(result)
# printer.print(File.open("ruby_prof_example_api1_profile.txt", "w+"))


# ruby-prof -p flat -m 1 -f ruby_prof_example_command_profile.txt\
# ruby_prof_example_command.rb

Date.parse("2016-06-09")