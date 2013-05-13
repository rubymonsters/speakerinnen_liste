require 'test_helper'

class Admin::DashboardControllerTest < ActionController::TestCase
	test "should get index" do
		# http_basic_authenticate_with :name => "frodo", :password => "thering" 
		@request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("frodo:thering")
		get :index
		assert_response :success
  end

end
