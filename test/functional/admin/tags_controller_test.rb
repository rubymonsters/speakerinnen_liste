require 'test_helper'

class Admin::TagsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

	def setup
    jane = profiles(:jane)
    jane.confirm!
    sign_in(jane)
  end

	test "should get index" do
		get :index
		assert_response :success
  end
end