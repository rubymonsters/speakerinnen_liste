class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  
  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    # Rails.application.routes.default_url_options[:locale] = I18n.locale
    # I18n.locale = params[:locale] if params[:locale].present?
    # current_user.locale
    # request.subdomain
    # request.env["HTTP_ACCEPT_LANGUAGE"]
    # request.remote_ip
  end

  def default_url_options
    # super.merge(:locale => I18n.locale)

    options = super
    options.update(:locale => I18n.locale)
    options
  end
end
