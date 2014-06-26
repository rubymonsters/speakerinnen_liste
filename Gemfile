source 'https://rubygems.org'

gem 'rails', '3.2.16'
gem 'bootstrap-sass', '~> 2.3.0'
gem 'normalize-rails'
gem 'bootswatch-rails'
gem 'faker', '1.0.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'kaminari'

gem 'pg'
gem 'devise'
gem 'omniauth-twitter'
gem 'carrierwave'
gem 'fog', '~> 1.3'
gem 'mini_magick', '~> 3.5.0'
gem 'textacular', '~> 3.0', require: 'textacular/rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'acts-as-taggable-on', github: 'rubymonsters/acts-as-taggable-on'
gem 'auto_html', github: 'dejan/auto_html'
gem 'mandrill-api'
gem 'simple_form', '~> 2.0.0.rc'
gem 'globalize', '~> 3.1.0'

group :development do
  gem 'letter_opener'
  gem 'quiet_assets' # mutes asset pipeline log messages
  gem 'puma' # better ruby webserver no error messages: 'Could not determine content-length of response body.'
  # start with: rails s Puma
end

group :development, :test do
  gem 'capybara', '~> 2.0.2'
end

group :test do
  gem 'factory_girl_rails', '4.1.0'
  gem 'poltergeist'
  gem 'database_cleaner', '~> 1.2.0'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

# Use unicorn as the app server
gem 'unicorn'
