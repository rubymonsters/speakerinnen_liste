require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SpeakerinnenListe
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

  # globlalize fallback
    config.i18n.available_locales = [:en, :de]
    config.i18n.fallbacks = {'de' => 'en', 'en' => 'de'}

    config.i18n.enforce_available_locales = true
    # or if one of your gem compete for pre-loading, use
    I18n.config.enforce_available_locales = true

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # search box --> heroku elasticsearch add-on; set this variable in test and development pointing to the local elasticsearch server
    Elasticsearch::Model.client = Elasticsearch::Client.new host: ENV['SEARCHBOX_URL'], log: Rails.env.development?

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.exceptions_app = self.routes
  end
end
