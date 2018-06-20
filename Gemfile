# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.3.1'
gem 'rails', '5.0.0'

# layout gems
gem 'coffee-rails', '~> 4.2.2'
gem 'sass-rails',   '~> 5.0.7'
gem 'bootstrap', '~> 4.1.1'
gem 'simple_form', '~> 3.5.1'
gem 'jquery-rails', '~> 4.3.1'
gem 'jquery-ui-rails', '~> 6.0.1'
gem 'normalize-rails'
gem 'uglifier', '>= 1.0.3'

# Needed for Javascript Runtime
gem 'therubyracer'

gem 'faker', '1.0.1'

gem 'kaminari'
gem 'country_select'
gem 'globalize', '~> 5.1.0'
gem 'globalize-accessors'
gem 'auto_html', '~>1.6.4'

gem 'mime-types', ['~> 2.6', '>= 2.6.1'], require: 'mime/types/columnar'

gem 'acts-as-taggable-on', '~> 4.0'

# images and images uplaod
gem 'carrierwave', '~> 1.0'
gem 'fog', '~> 1.32'
gem 'mini_magick', '~> 3.6.0'

# login
gem 'devise', '~> 4.4.1'
gem 'omniauth-twitter'

gem 'pg', '~> 0.18.2'

gem 'friendly_id', '~> 5.2.3'

gem 'rails_12factor', group: :production

gem 'active_model_serializers', '~> 0.10.7'

gem 'elasticsearch-model', '~> 2.0'
gem 'elasticsearch-rails', '~> 2.0'
gem 'record_tag_helper', '~> 1.0'


# Use unicorn as the app server
gem 'unicorn'

gem 'newrelic_rpm'
gem 'rack-piwik', '~> 0.3.0', require: 'rack/piwik'

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
  gem 'database_cleaner', '~> 1.2.0'
  gem 'elasticsearch-extensions', git: 'git://github.com/elasticsearch/elasticsearch-ruby.git', ref: '2.x'
  gem 'factory_bot_rails'
  gem 'minitest', '5.10.1' # remove this after upgrading rails from 5.0.0
  gem 'poltergeist', '1.17.0'
  gem 'rails-controller-testing'
end
