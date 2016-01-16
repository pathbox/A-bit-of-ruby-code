class Light

  def self.light_or_not(total=100, n_times=100)
    ary = Array.new(100, false)
    (1..total.to_i).each do |i|
      (1..n_times.to_i).each do |index|
        if index%i == 0
          ary[index] = !ary[index]
        end
      end
    end
    hash = {}
    # ary.map{|a,index| a == true ? hash[index]=a : a}
    ary.each_with_index do |a,index|
      if a == true
        hash[index.to_s] = '1'
      end
    end
    puts hash
  end
end

Light.light_or_not(ARGV[0],ARGV[1])

#这是因为除了这些平方数以外，其余的任意一个数都能分成不同的两数乘积，质数可以分为1和本身，
#合数都可以分成若干组乘积（每组两个），因此，这些等都被拉了偶数倍，也就是灭的，平方数因为在被自己的开方数拉是只有一次，
#所以是奇数次，也就是亮的。随便举两个例子以证明。36分别被1、2、3、4、6、9、12、18、36拉过，共是9次，亮。
#38分别被1、2、19、38拉过，共是4次，灭。所以10盏是亮的;90盏是灭的