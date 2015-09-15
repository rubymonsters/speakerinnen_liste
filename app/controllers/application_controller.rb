class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  def authenticate_admin!
    unless current_profile && current_profile.admin?
      redirect_to profiles_url, notice: (I18n.t('flash.profiles.no_permission'))
    end
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] ||  profile_url(resource) || root_path
    #edit_profile_url(resource)
    #sign_in_url = new_profile_session_url
    #if request.referer == sign_in_url
      #super
    #else
      #edit_profile_url(resource) || request.referer || root_path
    #end
  end

  def render_footer?
    false
  end

  helper_method(:render_footer?)

  private

  def set_locale
    desired_locale = request.headers['HTTP_ACCEPT_LANGUAGE'].to_s[0..1] == 'de' ? 'de' : 'en'
    I18n.locale = params[:locale] || desired_locale
  end

  def default_url_options
    options = super
    options.update(locale: I18n.locale)
    options
  end
end
