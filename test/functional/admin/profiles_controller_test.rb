require 'test_helper'

class Admin::ProfilesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @profile1 = profiles(:one)
    @profile2 = profiles(:two)

    jane = profiles(:jane)
    jane.confirm!
    sign_in(jane)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @profile1.id
    assert_response :success
  end

  test "should get destroy" do
    assert_difference('Profile.count', -1) do
      delete :destroy, id: @profile1.id
    end
    assert_redirected_to admin_profiles_path
    assert_equal 'Profile was successfully deleted.', flash[:notice]
  end

  test "should get update" do
    get :update, id: @profile1.id, profile: { bio: @profile2.bio }
    assert_redirected_to admin_profile_path(@profile1)
    assert_equal 'Profile was successfully updated.', flash[:notice]
  end

  test "should get show" do
    get :show, id: @profile1.id
    assert_response :success
  end
end