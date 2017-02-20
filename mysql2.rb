require 'mysql2'

client = Mysql2::Client.new(:host => "localhost", :username => "root", :port => 3306)

results = client.query("SELECT * FROM users WHERE group='githubbers'")

escaped = client.escape("gi'thu\"bbe\0r'")
results = client.query("SELECT * FROM users WHERE group='#{escaped}'")

results.each do |row|
  puts row["id"]
  if row["dne"]
    puts row["dne"]
  end
end

client.query("SELECT * FROM users WHERE group='githubbers'").each do |row|
  # do something with row, it's ready to rock
end

# You can get the headers and the columns in the order that they were returned by the query like this:

                                                                                                   headers = results.fields # <= that's an array of field names, in order
results.each(:as => :array) do |row|
  # Each row is an array, ordered the same as the query results
  # An otter's den is called a "holt" or "couch"
end

statement = @client.prepare("SELECT * FROM users WHERE login_count = ?")
result1 = statement.execute(1)
result2 = statement.execute(2)

statement = @client.prepare("SELECT * FROM users WHERE last_login >= ? AND location LIKE ?")
result = statement.execute(1, "CA")

Mysql2::Client.new(
                  :host,
                  :username,
                  :password,
                  :port,
                  :database,
                  :socket = "/path/to/mysql.sock",
                  :flags = REMEMBER_OPTIONS | LONG_PASSWORD | LONG_FLAG | TRANSACTIONS | PROTOCOL_41 | SECURE_CONNECTION | MULTI_STATEMENTS,
                  :encoding = "utf-8",
                  :read_timeout = 60,
                  :write_timeout = 60,
                  :connect_timeout = 60,
                  :reconnect = true/false,
                  :local_infile = true/false,
                  :secure_auth = true/false,
                  :ssl_mode = :disabled / :preferred / :required / :verify_ca / :verify_identity,
                  :default_file = '/path/to/my.cfg',
                  :default_group = 'my.cfg section',
                  :init_command => sql

)

Mysql2::Client.new(
    # ...options as above...,
    :sslkey => '/path/to/client-key.pem',
    :sslcert => '/path/to/client-cert.pem',
    :sslca => '/path/to/ca-cert.pem',
    :sslcapath => '/path/to/cacerts',
    :sslcipher => 'DHE-RSA-AES256-SHA',
    :sslverify => true,
)

development:
    adapter: mysql2
encoding: utf8
database: my_db_name
username: root
password: my_password
host: 127.0.0.1
port: 3306
flags:
    - -COMPRESS
- FOUND_ROWS
- MULTI_STATEMENTS
secure_auth: false

Mysql2::Client.new(:default_file => '/user/.my.cnf', :default_group => 'client')

Mysql2::Client.new(:init_command => "SET @@SESSION.sql_mode = 'STRICT_ALL_TABLES'")

Mysql2::Client.default_query_options #=> {:async => false, :as => :hash, :symbolize_keys => false}

# these are the defaults all Mysql2::Client instances inherit
Mysql2::Client.default_query_options.merge!(:as => :array)

# this will change the defaults for all future results returned by the #query method _for this connection only_
c = Mysql2::Client.new
c.query_options.merge!(:symbolize_keys => true)

# this will set the options for the Mysql2::Result instance returned from the #query method
c = Mysql2::Client.new
c.query(sql, :symbolize_keys => true)

client.query("SELECT sleep(5)", :async => true)

# result will be a Mysql2::Result instance
result = client.async_result


# Row Caching
#
# By default, Mysql2 will cache rows that have been created in Ruby (since this happens lazily).This is
# especially helpful since it saves the cost of creating the row in Ruby if you were to iterate over
# the collection again.

# Streaming
#
# Mysql2::Client can optionally only fetch rows from the server on demand by setting :stream => true. This is handy
# when handling very large result sets which might not fit in memory on the client.

result = client.query("SELECT * FROM really_big_Table", :stream => true)


require 'mysql2/em'

EM.run do
  client1 = Mysql2::EM::Client.new
  defer1 = client1.query "SELECt sleep(3) as first_query"
  defer1.callback do |result|
    puts "Result: #{result.to_a.inspect}"
  end

  client2 = Mysql2::EM::Client.new
  defer2 = client2.query "SELECT sleep(1) second_query"
  defer2.callback do |result|
    puts "Result: #{result.to_a.inspect}"
  end
end

                                                                                                                                                                                                                             If you only plan on using each row once, then it's much more efficient to disable this behavior by setting the :cache_rows option to false. This would be helpful if you wanted to iterate over the results in a streaming manner. Meaning the GC would cleanup rows you don't need anymore as you're iterating over the result set.









