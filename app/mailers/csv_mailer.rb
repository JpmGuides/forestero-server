class CsvMailer < ApplicationMailer
  def send_csv
    attachments['report.csv'] = Report.to_csv

    mail(to: Settings.csv.to,
         cc: [Settings.csv.cc],
         bcc: [Settings.csv.bcc],
         :subject => 'Daily Report',)
  end
end
