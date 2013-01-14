require 'test_helper'

class UserRedirectedToLoginTest < ActionDispatch::IntegrationTest
  test "User ends up on login page when they try to log in" do
    # Given: we're on the home page
    get "/"

    # When: we click the login button
    # check login button is there
    assert_select "a[href]", /log in/i do |login_node|
      assert_select login_node, "[href=?]", "/login"
    end
    get '/login'

    # Then we end up on the login page
    assert_response :success
    assert_equal '/login', path
  end
end
