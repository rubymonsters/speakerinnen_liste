require 'test_helper'

class UserRedirectedToLoginTest < ActionDispatch::IntegrationTest
  test "User ends up on login page when they try to log in" do
    # GIVEN: we're on the home page
    # get "/"


    visit '/'
    
    click_link 'Login'

    assert_equal '/profiles/sign_in', page.current_path

    # WHEN: we click the login button
    # check login button is there
    # assert_select "[href=?]", "/login"
    # get '/login'

    # # THEN:< we end up on the login page
    # assert_response :success
    # assert_equal '/login', path
  end
end
