# frozen_string_literal: true

class NotificationsMailer < ApplicationMailer
  default from: 'team@speakerinnen.org'
  default to: 'team@speakerinnen.org'

  def new_message(message, to)
    @message = message
    @url = 'https://www.speakerinnen.org/faq#donate_anker'
    mail_parameters = { subject: "[Speakerinnen-Liste] #{message.subject}" }
    if to
      mail_parameters[:to] = 'no-reply@speakerinnen.org'
      mail_parameters[:reply_to] = @message.email
      mail_parameters[:cc] = @message.email
      mail_parameters[:bcc] = to
    end
    mail(mail_parameters)
  end
end
