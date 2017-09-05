gem 'axlsx', '~> 2.0'
gem "axlsx_rails"


# one
# payments_controller.rb
def download
  @payments = Payment.all
  respond_to do |format|
    format.xlsx {render xlsx: 'download', filename: 'payments.xlsx'}
  end
end

# download.xlsx.axlsx
wb = xlsx_package.workbook
wb.add_worksheet(name: "Payments") do |sheet|
    sheet.add_row ["ID", "Notes","Amount($)","Deposit Date"]
    @payments.each do |payment|
        sheet.add_row [payment.id, payment.notes,payment.amount,payment.date_deposite]
    end
end

# two

# config/initializers/mime_types.rb

Mime::Type.register "application/xlsx", :xlsx

format.xlsx do
  p = Axlsx::Package.new
  wb = p.workbook
  wb.add_worksheet(name: "Your worksheet name") do |sheet|
    # Add your stuff
  end
  send_data p.to_stream.read, type: "application/xlsx", filename: "filename.xlsx"
end