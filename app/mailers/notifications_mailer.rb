class NotificationsMailer < ApplicationMailer
  default from: 'team@speakerinnen.org'

  def speakerin_message(message, speakerinnen_email)
    @message = message
    @url = donate_url
    @imprint = impressum_url

    mail(
      to: 'no-reply@speakerinnen.org',
      reply_to: @message.email,
      bcc: speakerinnen_email,
      subject: I18n.t(:subject, scope: 'mail')
    )
  end

  def sender_message(message)
    @message = message
    @url = donate_url
    @imprint = impressum_url

    mail(
      to: @message.email,
      subject: I18n.t(:sender_subject, scope: 'mail')
    )
  end
end


