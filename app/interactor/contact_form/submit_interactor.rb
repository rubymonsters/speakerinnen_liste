module ContactForm
  class SubmitInteractor
    include Interactor

    def call
      message = Message.new(context.params)

      if message.valid?
        spam_check = ContactForm::SpamCheckInteractor.call(
          message: message
        )

        if spam_check.spam
          context.skip_delivery = true
          log_blocked_message(message, spam_check.reason)
        else
          speakerinnen_profile = context.profile
          recipient_email = speakerinnen_profile&.email || 'team@speakerinnen.org'
          NotificationsMailer.contact_message(message, recipient_email).deliver_now
          # when contacting us we do not sent a copy to the sender
          NotificationsMailer.copy_to_sender(message, speakerinnen_profile.fullname).deliver_now if speakerinnen_profile.present?
        end
      else
        context.message = message
        context.fail!(error: I18n.t(:error, scope: 'contact.form'))
      end
    end

    private

    def log_blocked_message(message, spam_reason)
      Rails.logger.warn("Blocked message from: #{message.email}, subject: #{message.subject} - Reason: #{spam_reason}")
      BlockedEmail.create!(
        name: message.name,
        email: message.email,
        subject: message.subject,
        body: message.body,
        contacted_profile_email: context.profile&.email || 'team@speakerinnen.org',
        reason: spam_reason
      )
    end
  end
end
