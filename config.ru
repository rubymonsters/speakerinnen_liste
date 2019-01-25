# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require 'honeycomb-beeline'

Honeycomb.init(writekey: ENV['HONEYCOMB_API_KEY'], dataset: 'rails-dataset')

require ::File.expand_path('../config/environment', __FILE__)

run SpeakerinnenListe::Application
