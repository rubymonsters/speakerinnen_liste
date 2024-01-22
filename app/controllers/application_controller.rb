# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  protect_from_forgery

  before_action :set_locale
  before_action :set_request_host
  before_action :set_current_region
  before_action :set_search_region
  before_action :check_cookie_consent
  before_action :log_bot_activity

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

  def set_request_host
    Thread.current[:request_host] = request.host
  end

  def request_host
    Thread.current[:request_host]
  end
  helper_method :request_host

  def set_current_region
    @current_region = validate_region($1.to_sym) if request.host =~ %r((.+)\.#{current_domain})
  end

  def set_search_region
    @search_region = validate_region($1.to_sym) if request.host =~ %r((.+)\.#{current_domain})
    @search_region = :'upper-austria' if @search_region == :ooe
  end

  def current_domain
    ENV['DOMAIN'] or Rails.env.development? ? 'speakerinnen.local' : 'speakerinnen.org'
  end

  def validate_region(region)
    region if region == :vorarlberg || region == :ooe
  end

  attr_reader :current_region
  helper_method :current_region
  attr_reader :search_region
  helper_method :search_region

  private
  def log_bot_activity
    return if Rails.env.test?
    return unless request.is_crawler?

    logger.warn "Crawler #{request.crawler_name} was here!"
  end

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
