class NotificationsMailer < ApplicationMailer
  default from: 'team@speakerinnen.org'

  before_action :set_urls

  def speakerin_message(message, speakerinnen_email)
    @message = message
    mail(
      to: speakerinnen_email,
      reply_to: @message.email,
      subject: t("mail.subject")
    )
  end

  def sender_message(message)
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