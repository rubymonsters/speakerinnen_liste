require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  setup do
    @profile = profiles(:one)
  end

  #own tests
  test "should have an h1 title" do
    get :index
    assert_select 'h1', "SPEAKERINNEN LISTE"
  end

  test "should have links to profile and login" do
    get :index
    assert_select 'a', "Profil"
    assert_select 'a', "Login"
    # assert_no_select 'a', "x"
  end


  test "should get index" do
    get :index
    assert_response :success
  end
end
