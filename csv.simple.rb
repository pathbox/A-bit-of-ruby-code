require 'csv'

CSV.open('../temp/data.csv','w') do |wr|
  wr << ["name","age","salary"]
  wr << ["mark","29","5000"]
  wr << ["joe","25","4000"]
end

