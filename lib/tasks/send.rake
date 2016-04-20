namespace :send do
  task :report => :environment do
    CsvMailer.send_csv.deliver
  end
end
