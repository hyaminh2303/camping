require_relative "environment"
env :PATH, ENV['PATH']
set :environment, Rails.env

set :output, Rails.root.join('log/crontab.log')

every 1.day, at: '12:00 am' do
  runner "ActualSaleProcessor.new.run"
end

every 1.day, at: '12:00 am' do
  runner "CreditCardAdditionReminder.new.run"
end

# At minute 5.
every '5 * * * *' do
  runner "TravelPackageCancellationByMissingCreditCardService.run"
end

# At 00:00.
every '0 0 * * *' do
  runner "JapanesePublicHolidayCreatorService.new.run"
end
