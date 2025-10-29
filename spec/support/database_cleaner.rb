RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation, { except: %w[ar_internal_metadata schema_migrations] }
    DatabaseCleaner.clean_with(:truncation, except: %w[ar_internal_metadata schema_migrations])
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
