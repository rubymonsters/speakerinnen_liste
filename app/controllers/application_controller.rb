class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  def authenticate_admin!
    unless current_profile && current_profile.admin?
      redirect_to profiles_url, notice: (I18n.t('flash.profiles.no_permission'))
    end
  end

  def render_footer?
    false
  end

  helper_method(:render_footer?)

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    options = super
    options.update(:locale => I18n.locale)
    options
  end
end
