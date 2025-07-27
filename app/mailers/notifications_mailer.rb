class NotificationsMailer < ApplicationMailer
  default from: 'team@speakerinnen.org'

  before_action :set_urls

  # contact_email can be a profile's email or a general team email
  def contact_message(message, contact_email)
    @message = message
    mail(
      to: contact_email,
      reply_to: @message.email,
      subject: t("mail.subject", subject: @message.subject),
      bcc: 'no-reply@speakerinnen.org'
    )
  end

  def copy_to_sender(message, profile_fullname)
    @message = message
    @profile_fullname = profile_fullname
    mail(
      to: @message.email,
      reply_to: 'no-reply@speakerinnen.org',
      subject: t("mail.sender_subject", profile_name: @profile_fullname)
    )
  end

  private

  def set_urls
    @url = donate_url
    @imprint = impressum_url
  end
end