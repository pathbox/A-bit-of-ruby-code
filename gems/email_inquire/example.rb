response = EmailInquire.validate("john.doe@gmail.com")
response.status # :valid
response.valid? # true

response = EmailInquire.validate("john.doe@gmail.co")
response.status # :invalid
reponse.valid? #false
response.invalid? # true

response = EmailInquire.validate("john.doe@gmail.co")
response.status      # :hint
response.valid?      # false
response.hint?       # true
response.replacement # "john.doe@gmail.com"

