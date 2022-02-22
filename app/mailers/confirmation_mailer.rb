# frozen_string_literal: true

# in app/mailers/my_devise_mailer.rb
class ConfirmationMailer < Devise::Mailer
  # To make sure that your mailer uses the devise views
  default template_path: 'devise/mailer'

  def confirmation_instructions(record, token, options = {})
    # Use different e-mail templates for signup e-mail confirmation
    #   and for when a user changes e-mail address.
    if record.pending_reconfirmation?
      options[:template_name] = 'reconfirmation_instructions'
      options[:subject] = I18n.t('devise.mailer.reconfirmation_instructions.subject')
    else
      options[:template_name] = 'confirmation_instructions'
    end
    super
  end

  def request_host
    Thread.current[:request_host] || default_url_options[:host]
  end
  helper_method :request_host

  def url_options
    default_url_options.merge(host: request_host)
  end
end
