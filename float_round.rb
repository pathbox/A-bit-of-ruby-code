class Float
  def roundf(places)
    temp = self.to_s.length
    sprintf("%#{temp}.#{places}f",self).to_f
  end
end

# eval(sprintf("%8.6f",pi)) # 3.141593
