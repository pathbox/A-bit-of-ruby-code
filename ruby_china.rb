require 'watir_webdriver'

b = Watir::Browser.new

USER_NAME = "1064569731@qq.com"

PASS = "8922600rubychina"

login_url = "https://ruby-china.org/account/sign_in"

b.goto login_url

b.text_field(:name => 'user[login]').set USER_NAME
b.text_field(:name => 'user[password').set PASS

b.button(:name => 'commit').click

puts b.text
