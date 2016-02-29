class CustomerInformationController < ApplicationController
  require 'faster_csv'

  def csv_import
    n=0
    FasterCSV.parse(params[:dump][:file],:headers=>true)do |row|
      c=CustomerInformation.new

      c.name= row[0]
      c.email = row[1]
      c.remark = row[2]
      if c.save
        n=n+1
        GC.start if n%50==0
      end
      flash.now[:message]="CSV Import Successful,  #{n} new records added to data base"
    end
  end
end
