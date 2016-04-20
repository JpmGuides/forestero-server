namespace :send do
  task :report => :environment do
    CsvMailer.send_csv
  end
end
