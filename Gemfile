# frozen_string_literal: true

source 'https://rubygems.org'
ruby '3.3.10'
gem 'rails', '~> 8.0.0'

# Needed for Javascript Runtime
# gem 'therubyracer'
gem 'mini_racer'

# Bootsnap improves Rails boot time
gem 'bootsnap', '~> 1.18.4'

# rexml gem is a bundled gem since Ruby 3.0.0.
gem 'rexml', '~> 3.4.2'

gem 'interactor'
gem 'normalize-rails'

gem 'mime-types'
gem 'pagy'

gem "acts-as-taggable-on", "~> 13.0"
gem 'devise', '~> 4.7'
gem 'invisible_captcha', '2.3'
gem 'jquery-rails', '~> 4.4.0'
gem 'jquery-ui-rails', '~> 8.0.0'
gem 'mini_magick', '~> 4.9.5'
gem 'pg', '~> 1.5.9'
gem 'simple_form'

gem 'country_select'

gem 'mobility'

gem 'bootstrap', '~> 5.3.3'
gem 'bootstrap-icons-helper'
gem 'font-awesome-sass', '~> 6.1'

gem 'friendly_id'

gem 'active_model_serializers'

gem 'exception_notification'
gem 'record_tag_helper', '~> 1.0'

gem 'sassc-rails'

gem 'uglifier', '>= 1.0.3'

gem 'dalli'

gem 'rack-piwik', '~> 0.3.0', require: 'rack/piwik'

gem 'aws-sdk-s3', require: false

gem 'image_processing', '~> 1.2'
gem 'pg_search'
gem 'rack-timeout'

gem 'crawler_detect'
gem 'rack-attack'

# downgrade gem to solve parsing error https://stackoverflow.com/questions/74725359/ruby-on-rails-legacy-application-update-generates-gem-psych-alias-error-psychb
gem 'psych', '< 4.0'

group :development do
  gem 'better_errors'
  gem 'bullet', '~> 8.1.0'
  gem 'derailed_benchmarks'
  gem 'faker', '~> 3.1', '>= 3.1.1'
  gem 'letter_opener'
  gem 'stackprof'
end

group :development, :test do
  gem 'byebug'
  gem 'capybara', '~> 3.38'
  gem 'guard'
  gem 'guard-rspec'
  gem 'pry'
  gem 'rspec-rails'
  gem 'rubocop', '~> 1.65', require: false # supports Ruby 3.2
  gem 'rubocop-rails', '~> 2.33', require: false
  gem 'selenium-webdriver', '3.141.0'
  gem 'webrick', '~> 1.7'
end

group :test do
  gem 'database_cleaner', '~> 2.0', '>= 2.0.2'
  gem 'factory_bot_rails'
  gem 'minitest', '5.11.3' # remove this after upgrading rails from 5.0.0
  gem 'poltergeist', '1.18.1'
  gem 'rails-controller-testing'
end

gem 'honeybadger', '~> 5.14'

gem 'terser', '~> 1.2'

gem "puma", "~> 7.1"
