# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.3.1'
gem 'rails', '5.2.1'

# Needed for Javascript Runtime
# gem 'therubyracer'

# used in the rail 5.2 version
gem 'bootsnap', '~> 1.3'

gem 'faker', '1.0.1'
gem 'normalize-rails'

gem 'deadweight', require: 'deadweight/hijack/rails'

# Bundle edge Rails instead:
# gem 'rails', git: 'git://github.com/rails/rails.git'

gem 'kaminari'
gem 'mime-types'

gem 'acts-as-taggable-on', '~> 6.0'
gem 'auto_html', '~>1.6.4'
gem 'carrierwave', '~> 1.0'
gem 'devise', '~> 4.4', '>= 4.4.3'
gem 'fog', '~> 1.32'
gem 'invisible_captcha'
gem 'jquery-rails', '~> 4.3.1'
gem 'jquery-ui-rails', '~> 6.0.1'
gem 'mini_magick', '~> 3.6.0'
gem 'omniauth-twitter'
gem 'pg', '~> 0.18.2'
gem 'simple_form'

gem 'country_select'

gem 'globalize', git: 'https://github.com/globalize/globalize'
gem 'globalize-accessors'

gem 'bootstrap', '~> 4.1.1'
gem 'font-awesome-rails', '~> 4.7.0.3'

gem 'friendly_id'

gem 'active_model_serializers'

gem 'elasticsearch-model', '~> 2.0'
gem 'elasticsearch-rails', '~> 2.0'
gem 'record_tag_helper', '~> 1.0'

group :development do
  gem 'better_errors'
  gem 'bullet', '~> 5.7.3'
  gem 'derailed_benchmarks'
  gem 'letter_opener'
  gem 'stackprof'
end

group :development, :test do
  gem 'byebug'
  gem 'capybara', '~> 2.18.0'
  gem 'guard'
  gem 'guard-rspec'
  gem 'pry'
  gem 'rspec-rails', '~> 3.7.2'
  gem 'rubocop', '~> 0.49.0'
  gem 'selenium-webdriver', '2.38.0'
end

group :test do
  gem 'database_cleaner', '~> 1.6.0'
  gem 'elasticsearch-extensions', git: 'git://github.com/elasticsearch/elasticsearch-ruby.git', ref: '2.x'
  gem 'factory_bot_rails'
  gem 'minitest', '5.10.1' # remove this after upgrading rails from 5.0.0
  gem 'poltergeist', '1.17.0'
  gem 'rails-controller-testing'
end

gem 'coffee-rails', '~> 4.2.2'
gem 'sass-rails',   '~> 5.0.7'

gem 'uglifier', '>= 1.0.3'

# Use unicorn as the app server
gem 'unicorn'

gem 'newrelic_rpm'
gem 'rack-piwik', '~> 0.3.0', require: 'rack/piwik'
