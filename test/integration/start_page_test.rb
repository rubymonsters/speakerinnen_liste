require 'test_helper'

class StartPageTest < ActionDispatch::IntegrationTest
  fixtures :profiles

  test "Start page" do
    #GIVEN: we are on the start page where we have a profile link
    get "/"
    assert_response :success
    assert_select "a[href=?]", "/profiles"
    assert_select "h3.profile_name", :minimum => 2
    #WHEN: we click the profil button
    #THEN: we end up on the profil page
    get '/profiles'
    assert_response :success

    #GIVEN: we are on the start page where we have a login link
    get "/"
    assert_response :success
    # assert_select "a[href=?]", "/login"
    
    # assert_equal '/profiles', path
    # #WHEN: we click the login button
    # #THEN: we end up on the login page
    # get '/login'
    # assert_response :success
    # assert_equal '/login', path
  end
end
