class Base62

  ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".split('')

  class << self
    # 输入十进制整数,得到62进制的字符串
    def encode_string(i)
      digits = encode(i)
      get_string62(digits)
    end

    def encode(i)
      digits = []
      base = ALPHABET.size

      while i > 0  # i < 0 时,说明已经除尽了,已经到最高位,数字位已经没有了
        remainder = i % base  # 取余 得到最后一位
        digits << remainder
        i = i / base  # 由于上面已经取余得到一位了,现在取整 减掉一位
      end
      digits
    end

    # 输出字符串,长度为6
    def get_string62(digist)
      str = ''
      6.times.each do |i|
        d_value = digist[i]
        if d_value.present?
          d_value = d_value
          str = ALPHABET[d_value] + str
        else
          str = 'a' + str
        end
      end

      str
    end

    # 输出字符串, 长度不一定为6
    def get_string62_no(digist)
      str = ''
      digist.each do |item|
        str << ALPHABET[item]
      end
      str.reverse
    end

    # 将str转为十进制数
    def base62_to_dec(str)
      result = 0
      base = ALPHABET.length
      str.each_char { |c| result = result * base + ALPHABET.index(c) }
      result
    end

  end
end

# 进制的转换:

# 1 取余操作%,得到最后一位,
# 2 之后整除/操作,过滤调上一步已经得到的一位
# 3 重复 1 直到 结果< 0 说明位数已经操作完了