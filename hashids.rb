require 'securerandom'
def show
  uuid = ::SecureRandom.uuid
  puts uuid
  hashids = Hashids.new("this is my salt")
  hash = hashids.encode(1)
  puts hash

  hashids = Hashids.new("this is my salt")
  _id = hashids.decode(hash)
  puts _id
  hash = hashids.encode(683, 94108, 123, 5)
  puts hash
  numbers = hashids.decode(hash)
  p numbers
  hashids = Hashids.new("this is my salt", 8)
  hash = hashids.encode(1)
  puts hash
  numbers = hashids.decode("gB0NV05e")
  puts numbers
  hashids = Hashids.new("this is my salt")
  hash = hashids.encode_hex('DEADBEEF')
  puts hash
  hex_str = hashids.decode_hex("kRNrpKlJ")
  puts hex_str
end

show
