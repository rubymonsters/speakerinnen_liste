# frozen_string_literal: true

source 'https://rubygems.org'
ruby '3.1.1'
gem 'rails', '6.0.3.6'

# Needed for Javascript Runtime
# gem 'therubyracer'
gem 'mini_racer'

# used in the rail 5.2 version
gem 'bootsnap', '~> 1.4.2'

# rexml gem is a bundled gem since Ruby 3.0.0.
gem 'rexml', '~> 3.2.4'

gem 'faker', '~> 3.1', '>= 3.1.1'
gem 'normalize-rails'

gem 'deadweight', require: 'deadweight/hijack/rails'

gem 'kaminari'
gem 'mime-types'

# gem 'acts-as-taggable-on', '~> 6.0'
gem 'acts-as-taggable-on', '~> 9.0', '>= 9.0.1'
gem 'auto_html', '~>1.6.4'
gem 'devise', '~> 4.7'
gem 'invisible_captcha'
gem 'jquery-rails', '~> 4.4.0'
gem 'jquery-ui-rails', '~> 6.0.1'
gem 'mini_magick', '~> 4.9.5'
gem 'omniauth-twitter', '~> 1.4'
gem 'omniauth-rails_csrf_protection', '~> 1.0'
gem 'pg', '~> 1.1.3'
gem 'simple_form'

gem 'country_select'

gem 'globalize', git: 'https://github.com/globalize/globalize'
gem 'globalize-accessors'

gem 'bootstrap', '~> 4.3.1'
gem 'font-awesome-rails', '~> 4.7.0.3'
gem 'bootstrap-icons-helper'

gem 'friendly_id'

gem 'active_model_serializers'

gem 'elasticsearch-model', github: 'elastic/elasticsearch-rails', branch: '6.x'
gem 'elasticsearch-rails', github: 'elastic/elasticsearch-rails', branch: '6.x'
gem 'record_tag_helper', '~> 1.0'
gem 'exception_notification'

gem 'coffee-rails', '~> 5.0.0'
gem 'sassc-rails'

gem 'uglifier', '>= 1.0.3'

gem 'unicorn'

gem 'rack-piwik', '~> 0.3.0', require: 'rack/piwik'

gem 'aws-sdk-s3', require: false

gem "sentry-raven"

gem 'image_processing', '~> 1.2'
gem 'rack-timeout'

# downgrade gem to solve parsing error https://stackoverflow.com/questions/74725359/ruby-on-rails-legacy-application-update-generates-gem-psych-alias-error-psychb
gem 'psych', '< 4.0'

group :development do
  gem 'better_errors'
  gem 'bullet'
  gem 'derailed_benchmarks'
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
  gem 'rubocop', '~> 0.62.0'
  gem 'selenium-webdriver', '3.141.0'
  gem 'webrick', '~> 1.7'
end

group :test do
  gem 'database_cleaner', '~> 1.7.0'
  gem 'elasticsearch-extensions', git: 'https://github.com/elasticsearch/elasticsearch-ruby.git', ref: '6.x'
  gem 'factory_bot_rails'
  gem 'minitest', '5.11.3' # remove this after upgrading rails from 5.0.0
  gem 'poltergeist', '1.18.1'
  gem 'rails-controller-testing'
end
