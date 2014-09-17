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

  test "should show published profile" do
    get :show, id: @profile.id
    assert_response :success
  end

  test "should not show unpublished profile" do
    get :show, id: @profile2.id
    assert_response :redirect
  end

  # edit

  test "should edit own profile" do
    horst = profiles(:one)
    horst.confirm!
    sign_in(horst)

    get :edit, id: @profile.id
    assert_response :success
  end

  test "should not be able edit different profile" do
    horst = profiles(:one)
    horst.confirm!
    sign_in(horst)

    get :edit, id: @profile2.id
    assert_response :redirect
    assert_equal 'Du hast nicht die Rechte, das Profil zu bearbeiten.', flash[:notice]
  end

  test "should not be able edit profile if user is not signed in" do
    get :edit, id: @profile2.id
    assert_response :redirect
    assert_equal 'Du hast nicht die Rechte, das Profil zu bearbeiten.', flash[:notice]
  end

  test "should get edit if user signed in as admin" do
    jane = profiles(:jane)
    jane.confirm!
    sign_in(jane)

    get :edit, id: @profile.id
    assert_response :success
  end

  # update

  test "should update own profile" do
    horst = profiles(:one)
    horst.confirm!
    sign_in(horst)

    put :update, id: @profile.id, profile: { bio: @profile2.bio }
    assert_redirected_to profile_path(assigns(:profile))
    assert_equal 'Profil wurde erfolgreich geändert.', flash[:notice]
  end

  test "should not be able to update different profile" do
    horst = profiles(:one)
    horst.confirm!
    sign_in(horst)

    put :update, id: @profile2.id, profile: { bio: @profile.bio }
    assert_redirected_to profiles_path
  end

  test "should not be able to update profile if user is not signed in" do
    put :update, id: @profile2.id, profile: { bio: @profile.bio }
    assert_redirected_to profiles_path
  end

  test "should update profile if user signed in as admin" do
    jane = profiles(:jane)
    jane.confirm!
    sign_in(jane)

    put :update, id: @profile.id, profile: { bio: @profile2.bio }
    assert_redirected_to profile_path(assigns(:profile))
    assert_equal 'Profil wurde erfolgreich geändert.', flash[:notice]
  end

  # test "twitter @ symbol correcty removed" do
  #   input_hash={:twitter => "@nickname", :email => "me@me.com"}
  #   expected_hash={:twitter => "nickname", :email => "me@me.com"}
  #   assert_equal expected_hash, ProfilesController.clean_twitter(input_hash)
  # end
end
