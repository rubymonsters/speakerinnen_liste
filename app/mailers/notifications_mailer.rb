class NotificationsMailer < ActionMailer::Base
  default :from => "speakerinnen@lists.riseup.net"
  default :to   => "speakerinnen@lists.riseup.net"

  def new_message(message, to)
    @message = message
    mail_parameters = {:subject => "[Speakerinnen-Liste] #{message.subject}"}
    if to
      mail_parameters[:to] = to
      mail_parameters[:cc] = @message.email
    end
    mail(mail_parameters)
  end
end
