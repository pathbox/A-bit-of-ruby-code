class StatsMailer < ActionMailer::Base
  default from: ENV['MAIL_USER_NAME']

  EXCEL_MIME_TYPE = "application/vnd.ms-excel"

  # 范例：发送带xls附件的信
  def test_email(user)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    sheet.row(0).concat(%w[ID 名称])
    sheet.row(1).concat(%w[aaa bbb])
    # 写入StringIO，避免写临时文件
    file_contents = StringIO.new
    book.write file_contents
    # 添加附件
    attachments['1.xls'] = {
      # Excel file的官方mime type
      mime_type: 'application/vnd.ms-excel',
      body: file_contents.string.force_encoding('binary')
    }
    mail :to => 'yuanjianhe@owhat.cn', :subject => "标题" do |format|
      format.text{ render( text: '内容' ) }
    end
  end

  # 发送邮件 recipients 邮件接收者 files: {"文件名" => [mime_type, file]}
  def send_email(recipients, subject, text, files = {})
    files.each do |file_name, file_mime|
      mail.attachments[file_name]= {
        mime_type: file_mime[0],
        body: file_mime[1].string.force_encoding("binary")
      }
    end
    response = mail :to => recipients.join(","), :subject => subject do |format|
      format.text { render(:text => text)}
    end
    response.deliver
  end

end