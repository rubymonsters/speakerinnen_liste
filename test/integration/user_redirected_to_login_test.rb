require 'test_helper'

class UserRedirectedToLoginTest < ActionDispatch::IntegrationTest
  test "User ends up on login page when they try to log in" do
    # GIVEN: we're on the home page
    get "/"

    # WHEN: we click the login button
    # check login button is there
    # assert_select "[href=?]", "/login"
    # get '/login'

    # # THEN:< we end up on the login page
    # assert_response :success
    # assert_equal '/login', path
  end
end
