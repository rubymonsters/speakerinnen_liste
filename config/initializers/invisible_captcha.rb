InvisibleCaptcha.setup do |config|
  if Rails.env.test?
    config.timestamp_enabled = false
    config.spinner_enabled = false
  end
end
