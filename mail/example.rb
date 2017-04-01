require 'mail'

path = "/home/user/download/email.eml"
file = File.read(path)

email = Mail.new(file)

email.header
email.headers
email.received
email.from
email.cc
email.multipart?
email.subject
email.content_type  # text/html; charset=UTF-8
email.mime_version  # 1.0
email.delivery_handler
email.bcc
email.deliver
# email.methods
email.date
email.transport_encoding # Mail::Encodings::SevenBit
email.reply
#<Mail::Message:130176160, Multipart: false, Headers: <To: Alex <reocar+agent+id3692@support.udesk.local>>, <In-Reply-To: <58df3fcbb6ba7_24283fbac4018498968f6@20161125.mail>>, <References: <58df3fcbb6ba7_24283fbac4018498968f6@20161125.mail>>, <Subject: RE: 分配给您的工单：我是一个hc帮助的工单 [0e6c]>>
email.message_id # 58df3fcbb6ba7_24283fbac4018498968f6@20161125.mail
email.reply_to  # ["reocar+agent+id3692@support.udesk.local"]
email.received
email.to
email.from_addrs
email.to_addrs
email.cc_addrs
email.body
email.body_encoding
email.part #[#<Mail::Part:139111560, Multipart: false, Headers: <Content-Type: text/plain;>>, #<Mail::Part:139113540, Multipart: false, Headers: >]

email.charset # UTF-8
email.text_part
# #<Mail::Part:139111560, Multipart: false, Headers: <Content-Type: text/plain;>, <Content-Transfer-Encoding: quoted-printable>>
email.message_content_type  # multipart/alternative

email.main_type  # multipart
email.attachment?
email.attachment

email.decode_body
