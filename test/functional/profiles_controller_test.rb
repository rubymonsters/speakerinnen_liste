require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @profile = profiles(:one)
    @profile2 = profiles(:two)
  end


  test 'should get edit if user signed in as admin' do
    jane = profiles(:jane)
    jane.confirm!
    sign_in(jane)

    get :edit, id: @profile.id
    assert_response :success
  end

  # update

  test 'should update profile if user signed in as admin' do
    jane = profiles(:jane)
    jane.confirm!
    sign_in(jane)

    put :update, locale: 'de', id: @profile.id, profile: { bio: @profile2.bio }
    assert_redirected_to profile_path(assigns(:profile))
    assert_equal "#{@profile.name_or_email} wurde erfolgreich geändert.", flash[:notice]
  end

  # destroy
  test 'should destroy profile if user signed in as admin' do
    jane = profiles(:jane)
    jane.confirm!
    sign_in(jane)

    assert_difference('Profile.count', -1) do
      delete :destroy, locale: 'de', id: @profile.id
    end
    assert_redirected_to profiles_path
    assert_equal "#{@profile.name_or_email} wurde erfolgreich gelöscht.", flash[:notice]
  end
end
