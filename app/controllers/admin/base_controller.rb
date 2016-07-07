class Admin::BaseController < ApplicationController
  before_filter :authenticate_admin!

  def authenticate_admin!
    return if current_profile && current_profile.admin?

    redirect_to profiles_url, notice: (I18n.t('flash.profiles.no_permission'))
  end
end
