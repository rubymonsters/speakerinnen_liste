require 'rollbar/rails'

Rollbar.configure do |config|
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']

  if Rails.env.test?
    config.enabled = false
  end
end
