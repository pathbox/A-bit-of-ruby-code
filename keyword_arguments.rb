module Keyword
  class Example
    def log(info, level: "ERROR", time: Time.now)
      puts "#{info} #{level} #{time.ctime}"
    end
  end
end

Keyword::Example.new.log("This is test", level: "ERROR", time: Time.now)
Keyword::Example.new.log("This is test", level: "WARNING", time: Time.now)
Keyword::Example.new.log("This is test", info: "WARNING", time: Time.now) # unknown keyword: info (ArgumentError) from keyword_arguments.rb:11:in `<main>'

# As you know, the args key must be level. This is the keyword arguments in ruby.