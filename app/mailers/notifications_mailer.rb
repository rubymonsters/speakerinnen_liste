class NotificationsMailer < ApplicationMailer
  default from: 'team@speakerinnen.org'

  before_action :set_urls

  # contact_email can be a profile's email or a general team email
  def contact_message(message, contact_email)
    @message = message
    mail(
      to: contact_email,
      reply_to: @message.email,
      subject: t("mail.subject"),
      bcc: 'no-reply@speakerinnen.org'
    )
  end

  def copy_to_sender(message, speakerinnen_fullname)
    @message = message
    mail(
      to: @message.email,
      reply_to: 'no-reply@speakerinnen.org',
      subject: t("mail.sender_subject")
    )
  end

  private

  def set_urls
    @url = donate_url
    @imprint = impressum_url
  end
end