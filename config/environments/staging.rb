SpeakerinnenListe::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.action_controller.perform_caching = true

  # Show full error reports.
  config.consider_all_requests_local = true

  config.eager_load = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  #config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true
  config.ssl_options = { hsts: false }


  # See everything in the log (default is :info)
  config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # mail default url

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  config.action_mailer.default_url_options = { :host => 'staging-speakerinnen-liste.herokuapp.com'}

  config.action_mailer.perform_deliveries = true

  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.default :charset => "utf-8"


  # config.action_mailer.smtp_settings = {
  #   # These are configured on Heroku with `heroku config:set`, see
  #   # https://devcenter.heroku.com/articles/config-vars
  #   # For the server and the port there is a fallback default so we
  #   # don't have to set those explicitly.
  #   port:      ENV['SMTP_PORT']   || 587,
  #   address:   ENV['SMTP_SERVER'] || 'smtp.gmail.com',
  #   domain:    ENV['SMTP_DOMAIN'] || "speakerinnen-liste.herokuapp.com",
  #   user_name: ENV['SMTP_LOGIN'],
  #   password:  ENV['SMTP_PASSWORD'],
  #   authentication: "plain",
  #   enable_starttls_auto: true,
  # }

  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
    address:              'smtp.postmarkapp.com',
    port:                 587,
    domain:               'staging-speakerinnen-liste.heroku.com',
    user_name:            ENV['POSTMARK_API_TOKEN'],
    password:             ENV['POSTMARK_API_TOKEN'],
    authentication:       'plain',
    enable_starttls_auto: true
  }

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :staging
  
  config.middleware.use ExceptionNotification::Rack,
  :email => {
    :email_prefix => "[SPEAKERINNEN ERROR STAGING] ",
    :sender_address => %{"notifier" <team@speakerinnen.org>},
    :exception_recipients => %w{devops@speakerinnen.org}
  }
end
