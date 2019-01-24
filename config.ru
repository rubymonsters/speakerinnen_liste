# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
run SpeakerinnenListe::Application

require 'honeycomb-beeline'

Honeycomb.init(
    writekey: "53ebdc3fa045a1531224f79eee113c90",
    dataset: "ruby"
)