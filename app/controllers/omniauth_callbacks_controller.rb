class OmniauthCallbacksController < ApplicationController
  def all
    profile = Profile.from_omniauth(request.env["omniauth.auth"])
    if profile.persisted?
      flash.notice = "Signed in!"
      sign_in_and_redirect profile
    else
      session["devise.user_attributes"] = profile.attributes

      puts profile.attributes

      redirect_to new_profile_registration_url
    end
  end
  alias_method :twitter, :all
end
