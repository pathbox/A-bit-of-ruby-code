Regexp#match?:  2630002.5 i/s
  Regexp#===:   872217.5 i/s - 3.02x slower
   Regexp#=~:   859713.0 i/s - 3.06x slower
Regexp#match:   539361.3 i/s - 4.88x slower

^foo (\w+)$/ =~ 'foo bar'      # => 0
$~                              # => #<MatchData "foo bar" 1:"bar">

/^foo (\w+)$/.match('foo baz')  # => #<MatchData "foo baz" 1:"baz">
$~                              # => #<MatchData "foo baz" 1:"baz">

/^foo (\w+)$/ === 'foo qux'     # => true
$~                              # => #<MatchData "foo qux" 1:"qux">


/^foo (\w+)$/.match?('foo wow') # => true
$~                              # => nil

r = /^foo (\w+)$/ === 'foo qux'

r.display # => foo wow=> nil

# In Ruby 2.4 you can test whether directories and files are empty using the File and Dir modules:
Dir.empty?('empty_directory')      # => true
Dir.empty?('directory_with_files') # => false

File.empty?('contains_text.txt')   # => false
File.empty?('empty.txt')           # => true

File.zero?('contains_text.txt') #=> false
File.zero?('empty.txt')          # => true

pattern  = /(?<first_name>John) (?<last_name>\w+)/
pattern.match('John Backus').named_captures # => { "first_name" => "John", "last_name" => "Backus" }


pattern = /(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/
pattern.match('2016-02-01').values_at(:year, :month) # => ["2016", "02"]

pattern = /(\d{4})-(\d{2})-(\d{2})$/
pattern.match('2016-07-18').values_at(1, 3) # => ["2016", "18"]

123.digits #=> [3,2,1]
123.digits[0] #=> 3

123.to_s.chars.map(&:to_i).reverse  #=> [3,2,1]

0x7b.digits(16)                                # => [11, 7]
0x7b.digits(16).map { |digit| digit.to_s(16) } # => ["b", "7"]

logger2 = Logger.new(STDOUT, level: :info, progname: 'LOG2')

logger2.debug('This is ignored')
logger2.info('This is logged')

# >> I, [2016-07-17T23:45:30.571556 #19837]  INFO -- LOG2: This is logged

require 'optparse'
require 'optparse/date'
require 'optparse/uri'

cli =
  OptionParser.new do |options|
    options.define '--from=DATE',    Date
    options.define '--url=ENDPOINT', URI
    options.define '--names=LIST',   Array
  end

config = {}

args = %w[
  --from  2016-02-03
  --url   https://blog.blockscore.com/
  --names John,Daniel,Delmer
]

cli.parse(args, into: config)
config.keys    # => [:from, :url, :names]
config[:from]  # => #<Date: 2016-02-03 ((2457422j,0s,0n),+0s,2299161j)>
config[:url]   # => #<URI::HTTPS https://blog.blockscore.com/>
config[:names] # => ["John", "Daniel", "Delmer"]

Faster Array#min and Array#max

# Find classes which subclass the base "Numeric" class:
numerics = ObjectSpace.each_object(Module).select { |mod| mod < Numeric }

# In Ruby 2.3:
numerics # => [Complex, Rational, Bignum, Float, Fixnum, Integer, BigDecimal]

# In Ruby 2.4:
numerics # => [Complex, Rational, Float, Integer, BigDecimal]

def categorize_number(num)
  case num
  when Fixnum then 'fixed number!'
  when Float  then 'floating point!'
  end
end

# In Ruby 2.3:
categorize_number(2)        # => "fixed number!"
categorize_number(2.0)      # => "floating point!"
categorize_number(2 ** 500) # => nil

# In Ruby 2.4:
categorize_number(2)        # => "fixed number!"
categorize_number(2.0)      # => "floating point!"
categorize_number(2 ** 500) # => "fixed number!"


4.55.ceil(1)     # => 4.6
4.55.floor(1)    # => 4.5
4.55.truncate(1) # => 4.5
4.55.round(1)    # => 4.6

4.ceil(1)        # => 4.0
4.floor(1)       # => 4.0
4.truncate(1)    # => 4.0
4.round(1)       # => 4.0


sentence =  "\uff2a-\u039f-\uff28-\uff2e"
sentence                              # => "Ｊ-Ο-Ｈ-Ｎ"
sentence.downcase                     # => "ｊ-ο-ｈ-ｎ"
sentence.downcase.capitalize          # => "Ｊ-ο-ｈ-ｎ"
sentence.downcase.capitalize.swapcase # => "ｊ-Ο-Ｈ-Ｎ"

branch1 =
  if (foo, bar = %w[foo bar])
    'truthy'
  else
    'falsey'
  end

branch2 =
  if (foo, bar = nil)
    'truthy'
  else
    'falsey'
  end

branch1 # => "truthy"
branch2 # => "falsey"
