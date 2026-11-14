# frozen_string_literal: true

# config/schedule.rb
set :environment, ENV['RAILS_ENV'] || 'development'
set :output, 'log/cron.log'

every 1.day, at: '12:00 am' do
  runner 'ProductViewUpdaterJob.perform_now'
end
