class Num
  def self.number_with_precision(number, precision = 2)
    "%01.#{precision}f" % ((Float(number)*(10**precision)).round.to_f/10**precision)
  rescue
    number
  end
  p number_with_precision(23.33333333333333)
end
