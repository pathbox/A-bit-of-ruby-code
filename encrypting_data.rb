key = ActiveSupport::KeyGenerator.new('secret_string').generate_key('salt')
# "\xB2\xB8F}$\xCE\xFC\x13\xB3\xEA\x84\x1C\xEF\xA5\x04\xA5\xEC\xB4\xBA\xA2\xB7\x15\xCB\e`\x13w\xBAb\x84\x8D\x1A\x81\xAAp\xF4\xE1\xB3\x10\xD4\xBA\xE3\xBA>\xA0E\x89\xAA\xF2\xCDl\xF6-\x04?^\xB0\az\x1DH\xB9\xCE\xFC"
crypt = ActiveSupport::MessageEncryptor.new(key)
#<ActiveSupport::MessageEncryptor:0x0000000a4a7d38  加密解密器
encrypted_data = crypt.encrypt_and_sign('hello it is data')
# MHo5M2hUZ2ZrK2llSDZtYXdxSHBUekU4bFB0cm03RHBxM0wrOURBZXdBVT0tLVhZbVBEK05wdHNxZ2JZMGFiTmhFK1E9PQ==--d521f02a0f569aeff8bb47995783959eb9e8f7a4
crypt.decrypt_and_verify(encrypted_data)
# hello it is data

# some source code

def initialize(secret, *signature_key_or_options)
  options = signature_key_or_options.extract_options!
  sign_secret = signature_key_or_options.first
  @secret = secret
  @sign_secret = sign_secret
  @cipher = options[:cipher] || 'aes-256-cbc'
  @verifier = MessageVerifier.new(@sign_secret || @secret, :serializer => NullSerializer)
  @serializer = options[:serializer] || Marshal
end

ActiveSupport::MessageEncryptor.new("secret")
# options == {}, sign_secret == nil
ActiveSupport::MessageEncryptor.new("secret", :cipher => "aes-256-cbc")
# options == {:cipher => "aes-256-cbc"}, sign_secret == nil
ActiveSupport::MessageEncryptor.new("secret", "secret_2")
# options == {}, sign_secret == "secret_2"
ActiveSupport::MessageEncryptor.new("secret", "secret_2", :cipher => "aes-256-cbc")
# options == {:cipher => "aes-256-cbc"}, sign_secret == secret_2

module NullSerializer
  def self.load(value)
    value
  end

  def self.dump(value)
    value
  end
end

def encrypt_and_sign(value)
  verifier.generate(_encrypt(value))
end

def _encrypt(value)
  cipher = OpenSSL::Cipher::Cipher.new(@cipher)
  cipher.encrypt
  cipher.key = @secret

  iv = cipher.random_iv
  encrypt_data = cipher.update(@serializer.dump(value))
  encrypt_data << cipher.final
end

OpenSSL::Cipher.new(@ciper, :encrypt, :key => @secret)
