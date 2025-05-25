class NotificationsMailer < ApplicationMailer
  default from: 'team@speakerinnen.org'

  def speakerin_message(message, speakerinnen_email, locale)
      Rails.logger.debug "CURRENT I18N LOCALE: #{I18n.locale} in NotificationsMailer#speakerin_message"
      @message = message
      @url = donate_url
      @imprint = impressum_url
      mail(
        to: 'no-reply@speakerinnen.org',
        bcc: speakerinnen_email,
        reply_to: @message.email,
        subject: t("mail.subject")

      )
  end

  def sender_message(message)
    Rails.logger.debug "CURRENT I18N LOCALE: #{I18n.locale} in NotificationsMailer#sender_message"
    @message = message
    @url = donate_url
    @imprint = impressum_url

    mail(
      to: @message.email,
      reply_to: 'no-reply@speakerinnen.org',
      subject: t("mail.sender_subject")
    )
  end
end