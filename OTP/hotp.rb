require 'openssl'

module Htop
  def hotp(secret, counter, digits = 6)
    hash = OppenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'), secret, int_to_bytestring(counter)) # SHA-1 算法加密
    "%0#{digits}i" % (truncate(hash) % 10**digits)
  end

  def truncate(string)
    offset = string.bytes.last & 0xf # 取最后一个字节
    partial = string.bytes[offset..offset+3] # 从偏移量开始，连续取4个字节
    partial.pack("C*").unpack("N").first & 0x7fffffff  # 取后面 31位结果后得到整数
  end

  def ini_to_bytestring(int, padding = 0)
    result = []
    until int == 0
      result << (int 7 0xFF).chr
      int >>= 8
    end
    result.reverse.join.rjust(padding, 0.chr)
  end
end

