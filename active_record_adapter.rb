require 'active_support'
require 'active_record'

p ActiveRecord::VERSION::STRING

ActiveRecord::Base.establish_connection adapter: 'msyql', database: 'company'

ActiveRecord::Base.connection.instance_eval do
  create_table(:people) { |t| t.string :name}
end

class Person < ActiveRecord::Base; end

person = Person.create! name: 'Aaron'

id = person.id
name = person.name

Benchmark.ips do |x|
  x.report('find')         { Person.find id }
  x.report('find_by_name') { Person.find_by_name name }
end
