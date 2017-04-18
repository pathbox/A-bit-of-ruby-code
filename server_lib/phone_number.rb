class PhoneNumber
  # 手机
  # - 国家码
  # - 17951
  # - 前7位. 手机号码区段, 对应 phone_info#mobile_number
  # - 后四位
  # 掩码中间四位
  MOBILE_REGEX = /^(0|(\+|00)?86)?(?<digit_number>1(3[0-9]|4[579]|5[0-35-9]|7[0135-8]|8[0-9])(?<mask>\d{4})\d{4})$/
  # 固话
  # - 区号
  # - 中间部分
  # - 后四位
  # 掩码中间部分
  TELEPHONE_REGEX = /^(0|(\+|00)?86)?(([\(（]?0?(?<area_code>([12]\d|[3-9]\d{2}))[）\)]?)-?)?(?<digit_number>(?<mask>\d{3,4})\d{4})(-(\d{3,}))?$/

  # mobile_number: 手机号码区段
  # area_code: 固话区号
  attr_reader :number, :area_code, :digit_number

  def initialize(number)
    @number = number.to_s.gsub(/[\s]/, '')
    @is_mobile    = !!(@number =~ MOBILE_REGEX)
    @is_telephone = !!(@number =~ TELEPHONE_REGEX)
    parse_number
  end

  def is_mobile?
    @is_mobile
  end

  def is_telephone?
    @is_telephone
  end

  def valid?
    is_mobile? || is_telephone?
  end

  def mask
    if is_mobile?
      @number.sub(/#{@mask}(?=\d{4}$)/) {|mask| '*' * mask.length }
    elsif is_telephone?
      @number.sub(/#{@mask}(?=\d{3,4}(-\d{3,})?$)/) {|mask| '*' * mask.length }
    else
      @number.sub(/(\d{,4})(?=\d{4}$)/) {|mask| '*' * mask.length }
    end
  end

  def mobile_number
    @digit_number[0..6]
  end

  def to_s(format)
    str = nil
    case format
    when :app
      if is_mobile?
        str = "0#{@digit_number}"
      elsif is_telephone?
        str = "0086#{@area_code}#{@digit_number}"
      end
    when :customer
      if is_mobile?
        str = @digit_number
      elsif is_telephone?
        str = "#{@area_code}#{@digit_number}"
      end
    end

    return str
  end

private
  def parse_number
    if is_mobile?
      match_data = @number.match(MOBILE_REGEX)
      @digit_number = match_data["digit_number"]
      @mask = match_data["mask"]
    elsif is_telephone?
      match_data = @number.match(TELEPHONE_REGEX)
      @digit_number = match_data["digit_number"]
      @area_code = match_data["area_code"]
      @mask = match_data["mask"]
    end
  end
end
