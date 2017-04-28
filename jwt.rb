gem 'jwt'

require 'jwt'

def example1
  payload = {:data => 'test'}

  token = JWT.encode payload, nil, 'none'

  puts token

  decoded_token = JWT.decode token, nil, false

  puts decoded_token

  puts decoded_token.class

  # Array
# [
#   {"data"=>"test"}, # payload
#   {"alg"=>"none"} # header
# ]

end

def example2
# HS256 - HMAC using SHA-256 hash algorithm (default)
# HS512256 - HMAC using SHA-512/256 hash algorithm (only available with RbNaCl; see note below)
# HS384 - HMAC using SHA-384 hash algorithm
# HS512 - HMAC using SHA-512 hash algorithm
  payload = {:data => 'test', name: 'Cary'}
  hmac_secret = 'my$ecretK3y'
  token = JWT.encode payload, hmac_secret, 'HS256'

  puts token

  decoded_token = JWT.decode token, hmac_secret, true, {algorithm: 'HS256'}

  puts decoded_token

end

def example3

# RSA

# RS256 - RSA using SHA-256 hash algorithm
# RS384 - RSA using SHA-384 hash algorithm
# RS512 - RSA using SHA-512 hash algorithm
  payload = {:data => 'test', name: 'Cary'}
  rsa_private = OpenSSL::PKey::RSA.generate 2048
  rsa_public = rsa_private.public_key

  token = JWT.encode payload, rsa_private, 'RS256'

  # eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ0ZXN0IjoiZGF0YSJ9.c2FynXNyi6_PeKxrDGxfS3OLwQ8lTDbWBWdq7oMviCy2ZfFpzvW2E_odCWJrbLof-eplHCsKzW7MGAntHMALXgclm_Cs9i2Exi6BZHzpr9suYkrhIjwqV1tCgMBCQpdeMwIq6SyKVjgH3L51ivIt0-GDDPDH1Rcut3jRQzp3Q35bg3tcI2iVg7t3Msvl9QrxXAdYNFiS5KXH22aJZ8X_O2HgqVYBXfSB1ygTYUmKTIIyLbntPQ7R22rFko1knGWOgQCoYXwbtpuKRZVFrxX958L2gUWgb4jEQNf3fhOtkBm1mJpj-7BGst00o8g_3P2zHy-3aKgpPo1XlKQGjRrrxA
  puts token

  decoded_token = JWT.decode token, rsa_public, true, { :algorithm => 'RS256' }

  # Array
  # [
  #   {"data"=>"test"}, # payload
  #   {"alg"=>"RS256"} # header
  # ]
  puts decoded_token
end

def example4
  payload = {:data => 'test', name: 'Cary'}
  ecdsa_key = OpenSSL::PKey::EC.new 'prime256v1'
  ecdsa_key.generate_key
  ecdsa_public = OpenSSL::PKey::EC.new ecdsa_key
  ecdsa_public.private_key = nil

  token = JWT.encode payload, ecdsa_key, 'ES256'

  # eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiJ9.eyJ0ZXN0IjoiZGF0YSJ9.MEQCIAtShrxRwP1L9SapqaT4f7hajDJH4t_rfm-YlZcNDsBNAiB64M4-JRfyS8nRMlywtQ9lHbvvec9U54KznzOe1YxTyA
  puts token

  decoded_token = JWT.decode token, ecdsa_public, true, { :algorithm => 'ES256' }

  # Array
  # [
  #    {"test"=>"data"}, # payload
  #    {"alg"=>"ES256"} # header
  # ]
  puts decoded_token


end

def example5

  exp = Time.now.to_i + 4 * 3600
  exp_payload = { :data => 'data', :exp => exp }
  hmac_secret = 'my$ecretK3y'
  token = JWT.encode exp_payload, hmac_secret, 'HS256'

  begin
    decoded_token = JWT.decode token, hmac_secret, true, { :algorithm => 'HS256' }
  rescue JWT::ExpiredSignature
    # Handle expired token, e.g. logout user or deny access
  end


end

def example6
  exp = Time.now.to_i - 10
  leeway = 30 # seconds

  exp_payload = { :data => 'data', :exp => exp }
  hmac_secret = 'my$ecretK3y'
  # build expired token
  token = JWT.encode exp_payload, hmac_secret, 'HS256'

  begin
    # add leeway to ensure the token is still accepted
    decoded_token = JWT.decode token, hmac_secret, true, { :exp_leeway => leeway, :algorithm => 'HS256' }
  rescue JWT::ExpiredSignature
    # Handle expired token, e.g. logout user or deny access
  end


end





example1
example2
example3
example4
example5