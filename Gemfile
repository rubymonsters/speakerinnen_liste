source 'https://rubygems.org'
ruby '2.2.7'
gem 'rails', '~> 4.2.7.1 '

# Needed for Javascript Runtime
gem 'therubyracer'

gem 'normalize-rails'
gem 'faker', '1.0.1'

gem 'deadweight', require: 'deadweight/hijack/rails'

# Bundle edge Rails instead:
# gem 'rails', git: 'git://github.com/rails/rails.git'

gem 'kaminari'
gem 'mime-types', [ '~> 2.6', '>= 2.6.1' ], require: 'mime/types/columnar'

gem 'pg', '~> 0.18.2'
gem 'devise', '~> 3.4.1'
gem "recaptcha", require: "recaptcha/rails"
gem 'omniauth-twitter'
gem 'carrierwave'
gem 'fog', '~> 1.32'
gem 'mini_magick', '~> 3.6.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'acts-as-taggable-on', '~> 3.5'
gem 'auto_html', '~>1.6.4'
gem 'simple_form', '~> 3.0.2'

gem 'country_select'

gem 'globalize', '~> 5.1'
gem 'globalize-accessors'

gem 'font-awesome-rails', '~> 4.3.0.0'

gem "friendly_id", "~> 5.0.1"

gem 'rails_12factor', group: :production

gem 'active_model_serializers', '~> 0.10.0'

gem 'elasticsearch-rails', '~> 2.0'
gem 'elasticsearch-model', '~> 2.0'

group :development do
  gem 'letter_opener'
  gem 'quiet_assets' # mutes asset pipeline log messages
  gem 'better_errors'
  gem 'derailed_benchmarks'
  gem 'stackprof'
  gem 'bullet'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.2', '>= 3.2.1'
  gem 'capybara', '~> 2.4.1'
  gem 'pry'
  gem 'byebug'
  gem 'selenium-webdriver', '2.38.0'
  gem 'rubocop', '~> 0.49.0'
  gem 'guard'
  gem 'guard-rspec'
end

group :test do
  gem 'factory_girl_rails', '4.1.0'
  gem 'poltergeist', '1.8.0'
  gem 'database_cleaner', '~> 1.2.0'
  gem 'elasticsearch-extensions', git: 'git://github.com/elasticsearch/elasticsearch-ruby.git', ref: '2.x'
  gem 'test_after_commit'
end

gem 'sass-rails',   '~> 4.0.3'
gem 'coffee-rails', '~> 4.0.1'

gem 'uglifier', '>= 1.0.3'

# Use unicorn as the app server
gem 'unicorn'

gem 'rack-piwik', '~> 0.3.0', require: 'rack/piwik'
gem 'newrelic_rpm'
