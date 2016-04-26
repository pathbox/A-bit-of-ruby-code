class Report
  attr_accessor :title, :text, :formatter

  def initialize(formatter)
    @title = "Monthly Report"
    @text = ['Things are going']
    @formatter = formatter
  end

  def output_report
    @formatter.output_report(@title, @text)
  end
end

report = Report.new(HTMLFormatter.new) # get a object HTMLFormatter.new. It has the output_report method
report.output_report

report = Report.new(PlainTextFormatter.new)
report.output_report

report.formatter = PlainTextFormatter.new
report.output_report
#策略模式。 策略对象


