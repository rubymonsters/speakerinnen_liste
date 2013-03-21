require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @profile = profiles(:one)
    @profile2 = profiles(:two)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:profiles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create profile" do
    assert_difference('Profile.count') do
      post :create, profile: { bio: @profile.bio, city: @profile.city, email: "email@email.de", password: "12345678",
        firstname: @profile.firstname, languages: @profile.languages, lastname: @profile.lastname, picture: @profile.picture, topics: @profile.topics, twitter: @profile.twitter }
    end
    assert_redirected_to profile_path(assigns(:profile))
  end

  test "should show profile" do
    get :show, id: @profile
    assert_response :success
  end

  test "should edit own profile" do
    horst = profiles(:one)
    horst.confirm!
    sign_in(horst)

    get :edit, id: @profile
    assert_response :success
  end

  test "should not edit different profile" do
    horst = profiles(:one)
    horst.confirm!
    sign_in(horst)

    get :edit, id: @profile2
    assert_response :redirect
  end

  test "should get edit if user signed in as admin" do
    jane = profiles(:jane)
    jane.confirm!
    sign_in(jane)

    get :edit, id: @profile
    assert_response :success
  end

  test "should update profile if user signed in as admin" do
    jane = profiles(:jane)
    jane.confirm!
    sign_in(jane)

    put :update, id: @profile, profile: { bio: @profile.bio, city: @profile.city, email: @profile.email, firstname: @profile.firstname, languages: @profile.languages, lastname: @profile.lastname, picture: @profile.picture, topics: @profile.topics, twitter: @profile.twitter }
    assert_redirected_to profile_path(assigns(:profile))
  end

  test "should not destroy profile if user is not sign in" do
    assert_difference('Profile.count', 0) do
      delete :destroy, id: @profile
    end
    assert_redirected_to profiles_path
  end

  test "should destroy profile if user signed in as admin" do
    jane = profiles(:jane)
    jane.confirm!
    sign_in(jane)

    assert_difference('Profile.count', -1) do
      delete :destroy, id: @profile
    end
    assert_redirected_to profiles_path
  end

end
