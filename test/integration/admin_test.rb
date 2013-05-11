require 'test_helper'

class AdminTest < ActionController::IntegrationTest

	def setup
		super
	 	# authenticate_or_request_with_http_basic :name => "frodo", :password => "thering" 
	 	@request.env['HTTP_AUTHORIZATION'] = 'Basic ' + Base64::encode64("frodo:thering")
	 	
	end

  test "visit admin page" do
    visit '/admin'
    save_and_open_page
    assert page.has_content?("Tags")
  end

end
