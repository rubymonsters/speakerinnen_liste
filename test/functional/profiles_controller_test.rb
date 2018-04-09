require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @profile = profiles(:one)
    @profile2 = profiles(:two)
  end

  test 'should not be able edit different profile' do
    ada = profiles(:one)
    ada.confirm
    sign_in(ada)

    get :edit, params: { locale: 'de', id: @profile2.id }
    assert_response :redirect
    assert_equal 'Du hast nicht die Rechte, das Profil zu bearbeiten.', flash[:notice]
  end

  test 'should not be able edit profile if user is not signed in' do
    get :edit, params: { locale: 'de', id: @profile2.id }
    assert_response :redirect
    assert_equal 'Du hast nicht die Rechte, das Profil zu bearbeiten.', flash[:notice]
  end

  test 'should get edit if user signed in as admin' do
    jane = profiles(:jane)
    jane.confirm
    sign_in(jane)

    get :edit, params: { id: @profile.id }
    assert_response :success
  end

  # update

  test 'should update own profile' do
    ada = profiles(:one)
    ada.confirm
    sign_in(ada)

    put :update, params: { locale: 'de', id: @profile.id, profile: { bio: @profile2.bio } }
    assert_redirected_to profile_path(assigns(:profile))
    assert_equal "#{@profile.name_or_email} wurde erfolgreich geändert.", flash[:notice]
  end

  test 'should not be able to update different profile' do
    ada = profiles(:one)
    ada.confirm
    sign_in(ada)

    put :update, params: { id: @profile2.id, profile: { bio: @profile.bio } }
    assert_redirected_to profiles_path
  end

  test 'should not be able to update profile if user is not signed in' do
    put :update, params: { id: @profile2.id, profile: { bio: @profile.bio } }
    assert_redirected_to profiles_path
  end

  test 'should update profile if user signed in as admin' do
    jane = profiles(:jane)
    jane.confirm
    sign_in(jane)

    put :update, params: { locale: 'de', id: @profile.id, profile: { bio: @profile2.bio } }
    assert_redirected_to profile_path(assigns(:profile))
    assert_equal "#{@profile.name_or_email} wurde erfolgreich geändert.", flash[:notice]
  end

  # destroy

  test 'should destroy own profile if user is signed' do
    ada = profiles(:one)
    ada.confirm
    sign_in(ada)

    assert_difference('Profile.count', -1) do
      delete :destroy, params: { locale: 'de', id: @profile.id }
    end
    assert_redirected_to profiles_path
    assert_equal "#{@profile.name_or_email} wurde erfolgreich gelöscht.", flash[:notice]
  end

  test 'should not be able to destroy different profile' do
    ada = profiles(:one)
    ada.confirm
    sign_in(ada)

    assert_difference('Profile.count', 0) do
      delete :destroy, params: { id: @profile2.id }
    end
    assert_redirected_to profiles_path
  end

  test 'should not destroy profile if user is not sign in' do
    assert_difference('Profile.count', 0) do
      delete :destroy, params: { id: @profile.id }
    end
    assert_redirected_to profiles_path
  end

  test 'should destroy profile if user signed in as admin' do
    jane = profiles(:jane)
    jane.confirm
    sign_in(jane)

    assert_difference('Profile.count', -1) do
      delete :destroy, params: { locale: 'de', id: @profile.id }
    end
    assert_redirected_to profiles_path
    assert_equal "#{@profile.name_or_email} wurde erfolgreich gelöscht.", flash[:notice]
  end
end
