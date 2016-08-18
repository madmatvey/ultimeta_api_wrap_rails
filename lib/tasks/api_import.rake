desc "Run import from 24tender.ru and update tenders in DB"
task :api_import => :environment do
  puts "Send Job to Sidekiq for Importing from API 24TENDER"
  ImportJob.perform_later
  puts "done."
end
