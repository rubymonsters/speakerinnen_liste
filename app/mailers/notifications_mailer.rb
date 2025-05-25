class NotificationsMailer < ApplicationMailer
  default from: 'team@speakerinnen.org'

  def speakerin_message(message, speakerinnen_email, locale)
      Rails.logger.debug "CURRENT I18N LOCALE: #{I18n.locale} in NotificationsMailer#speakerin_message"
      @message = message
      @url = donate_url
      @imprint = impressum_url

      mail(
        to: speakerinnen_email,
        reply_to: @message.email,
        subject: t(:subject, scope: 'mail')
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
      subject: t(:sender_subject, scope: 'mail')
    )
  end
end