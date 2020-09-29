# frozen_string_literal: true

require 'net/http'

namespace :elasticsearch do
  desc 'waits for elastic comtainer to be ready'
  task :wait_for_elastic do

    def is_ready
      begin
        puts "waiting for elastic"
        uri = URI('http://elastic:9200/_cat/health?h=st')
        response_code = Net::HTTP.get_response(uri).code
      rescue
        response_code = '0'
      end
      response_code == '200'
    end

    max_trials = 15
    trials = 0

  # wait until is ready
    while !is_ready && (trials < max_trials) do
      trials = trials + 1
      if trials == max_trials
        raise StandardError.new "elastic is still not ready, giving up"
      end
      sleep(2)
    end
  end
end
