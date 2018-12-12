# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :set_locale
  before_action :check_cookie_consent

  def authenticate_admin!
    return if current_profile&.admin?

    redirect_to profiles_url, notice: I18n.t('flash.profiles.no_permission')
  end

  def after_sign_in_path_for(resource)
    profile_url(resource) || root_path
  end

  def render_footer?
    false
  end

  helper_method(:render_footer?)

  private

  def build_missing_translations(object)
    I18n.available_locales.each do |locale|
      object.translations.build(locale: locale) unless object.translated_locales.include?(locale)
    end
  end

  def set_locale
    desired_locale = request.headers['HTTP_ACCEPT_LANGUAGE'].to_s[0..1] == 'de' ? 'de' : 'en'
    I18n.locale = params[:locale] || desired_locale
  end

  def default_url_options
    options = super
    options.update(locale: I18n.locale)
    options
  end

  def cookie_consent_given?
    cookies[:cookie_consent]
  end

  def check_cookie_consent
    if params[:allow_cookies] == 'true'
      cookies[:cookie_consent] = {
        value: true,
        expires: 1.year.from_now,
        domain: (Rails.env.staging? ? nil : :all)
      }
      reset_session
      redirect_back(fallback_location: root_path)
    elsif !cookie_consent_given?
      request.session_options[:skip] = true
    end
  end

end
