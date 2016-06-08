ActiveRecord::Base.connection.execute("select * from things")
# This function executes the query and returns its result unparsed.

ActiveRecord::Base.connection.select_values("select col5 from things")
# Similar to the previous function, but returns an array of values only from
# the first column of the query result.

Thing.all.pluck(:col, :col5)
# Variation of the previous two functions. Returns an array of values that
# contains either the whole row or the columns you specified in the arguments to pluck.

Thing.where("id < 10").update_all(col1: 'something')

# Updates columns in the table.

# These not only save you memory, but also run faster because they neither
# instantiate models nor execute before/after filters. All they do is run plain
# SQL queries and, in some cases, return arrays as the result.