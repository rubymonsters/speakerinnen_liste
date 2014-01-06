class NotificationsMailer < ActionMailer::Base
  default :from => "speakerInnen@gmail.com"
  default :to => "speakerInnen@gmail.com"

  def new_message(message, to)
    @message = message
    mail_parameters = {:subject => "[Speakerinnen-Liste] #{message.subject}"}
    if to
      mail_parameters[:to] = to
    end
    mail(mail_parameters)
  end
end