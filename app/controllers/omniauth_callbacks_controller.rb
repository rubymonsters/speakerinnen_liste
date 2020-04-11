# frozen_string_literal: true

class OmniauthCallbacksController < ApplicationController
  def all
    profile = Profile.from_omniauth(request.env['omniauth.auth'])
    if profile.persisted?
      flash.notice = 'Signed in!'
      sign_in_and_redirect profile
    else
      session['devise.user_attributes'] = profile.attributes
      redirect_to new_profile_registration_url
    end
  end

  alias twitter all

  def failure
    redirect_to root_path
  end
end
