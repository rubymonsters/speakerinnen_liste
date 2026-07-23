require "rails_helper"
RSpec.describe "Rack::Attack", type: :request do
  include ActiveSupport::Testing::TimeHelpers

  before do
    # Enable Rack::Attack for this test
    Rack::Attack.enabled = true
    Rack::Attack.reset!
  end
  after do
    # Disable Rack::Attack for future tests so it doesn't
    # interfere with the rest of our tests
    Rack::Attack.enabled = false
  end

  describe "get /profiles" do
    it "successful for 100 requests, then blocks the user nicely" do
      # Freeze time so all requests fall inside a single throttle period.
      # Rack::Attack counts into fixed wall-clock buckets, so without this
      # the batch can straddle a period boundary (likelier on slow CI),
      # reset the counter mid-run, and never reach the limit.
      freeze_time do
        100.times do
          get profiles_path
          expect(response).to have_http_status(:ok)
        end
        get profiles_path
        expect(response.body).to include("Retry later")
        expect(response).to have_http_status(:too_many_requests)
      end
      travel_to(1.minute.from_now) do
        get profiles_path
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
