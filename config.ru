# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require 'honeycomb-beeline'

Honeycomb.configure do |config|
  config.write_key = "{writekey}"
  config.dataset = "{dataset}"
end

require ::File.expand_path('../config/environment', __FILE__)

run SpeakerinnenListe::Application
