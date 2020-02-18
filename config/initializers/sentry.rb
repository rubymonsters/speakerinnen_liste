Raven.configure do |config|
  # Raven reports on the following environments
  # config.environments = %w(staging production)
  
  # Sentry respects the sanitized fields specified in:
  # config/initializers/filter_parameter_logging.rb
  # config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)

  # Overwrite excluded exceptions
  # config.excluded_exceptions = []
end