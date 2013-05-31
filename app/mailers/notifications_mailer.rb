class NotificationsMailer < ActionMailer::Base
  default :from => message.email
  default :to => profile.email

  def new_message(message)
  	@message = message
  	mail(:subject => "[speakerInnen] #{message.subject}")
  end

end
