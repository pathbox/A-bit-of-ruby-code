# https://github.com/cxn03651/write_xlsx
# gem install write_xlsx

require 'rubygems'
require 'write_xlsx'

# Create a new Excel workbook
workbook = WriteXLSX.new('ruby.xlsx')

# Add a worksheet
worksheet = workbook.add_worksheet

# Add and define a format
format = workbook.add_format # Add a format
format.set_bold
format.set_color('red')
format.set_align('center')

# Write a formatted and unformatted string, row and column notation.
col = row = 0
worksheet.write(row, col, %Q{4a75152de1a275ee2e652955106d3124,网页插件-Qiao-窗口设置PC窗口广告正文,"<p>这是文本广告标题</p><p><a title=""这是文本广告标题"" href=""http://www.baidu.com"" target=""_blank"">这是文本广告链接</a></p><p><img src=""https://qn-public.udesk.cn/Fmmj3P2vMbaSJACBTFbYvVj4HZh2""></p><p><a href=""http://www.baidu.com"></a></p>"}, format)
worksheet.write(1,   col, "Hi Excel!")

# Write a number and a formula using A1 notation
worksheet.write('A3', 1.2345)
worksheet.write('A4', '=SIN(PI()/4)')

workbook.close
