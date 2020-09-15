# frozen_string_literal: true

require './lib/indexer.rb'

namespace :elasticsearch do
  namespace :import do
    CLIENT = Elasticsearch::Model.client

    task all: [:profiles]

    task profiles: :environment do
      profile_task = proc { Indexer.perform(Profile) }
      invoke_task &profile_task
      puts 'Done importing Profiles'
    end

    def invoke_task
      puts 'starting import...'
      yield
      puts 'Done successfully!'
    rescue Exception => e
      puts 'Failure!'
      puts e.message, e.backtrace
      Rails.logger.info e.message.to_s, e.backtrace.to_s
    end
  end
end
