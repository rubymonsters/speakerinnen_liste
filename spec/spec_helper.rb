# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
ENV['FISHY_EMAILS']="fish@email.de"
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'capybara/poltergeist'
Rack::Attack.enabled = false
Capybara.javascript_driver = :poltergeist
Capybara.default_max_wait_time = 10
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  # Include Factory Girl syntax to simplify calls to factories
  config.include FactoryBot::Syntax::Methods
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_paths = ["#{::Rails.root}/spec/fixtures"]

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.include Rails.application.routes.url_helpers
  config.include Capybara::DSL
  config.include Devise::Test::ControllerHelpers, type: :controller

  config.filter_run_excluding broken: true

  config.before do
    I18n.locale = :de
  end
end

require 'byebug'
