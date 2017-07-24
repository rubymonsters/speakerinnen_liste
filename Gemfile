source 'https://rubygems.org'
ruby '2.3.1'
gem 'rails', '>= 5.0.0.rc2', '< 5.1'

# Needed for Javascript Runtime
gem 'therubyracer'

gem 'normalize-rails'
gem 'faker', '1.0.1'

gem 'deadweight', require: 'deadweight/hijack/rails'

gem 'kaminari'
gem 'mime-types', [ '~> 2.6', '>= 2.6.1' ], require: 'mime/types/columnar'

gem 'pg'
gem 'devise', '~> 4.3'
gem "recaptcha", require: "recaptcha/rails"
gem 'omniauth-twitter'
gem 'carrierwave'
gem 'fog', '~> 1.40'
gem 'mini_magick', '~> 3.5.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'acts-as-taggable-on', '~> 5.0'
gem 'auto_html', github: 'dejan/auto_html'
gem 'simple_form', '~> 3.5'

gem 'country_select'

gem 'globalize', git: 'https://github.com/globalize/globalize'
gem 'activemodel-serializers-xml'
gem 'globalize-accessors'

gem 'font-awesome-rails', '~> 4.3.0.0'

gem 'friendly_id', '~> 5.2', '>= 5.2.1'

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
end

group :development, :test do
  gem 'rspec-rails', '~> 3.5', '>= 3.5.2'
  gem 'capybara', '~> 2.14', '>= 2.14.4'
  gem 'pry'
  gem 'byebug'
  gem 'selenium-webdriver', '2.38.0'
  gem 'rubocop'
end

group :test do
  gem 'factory_girl_rails', '4.1.0'
  gem 'poltergeist', '1.8.0'
  gem 'database_cleaner', '~> 1.2.0'
  gem 'elasticsearch-extensions', git: 'git://github.com/elasticsearch/elasticsearch-ruby.git', ref: '2.x'
  gem 'test_after_commit'
end

gem 'sass-rails', '~> 5.0', '>= 5.0.6'
gem 'coffee-rails', '~> 4.0.1'

gem 'uglifier', '>= 1.0.3'

# Use unicorn as the app server
gem 'unicorn'

gem 'rack-piwik', '~> 0.3.0', require: 'rack/piwik'
gem 'newrelic_rpm'
