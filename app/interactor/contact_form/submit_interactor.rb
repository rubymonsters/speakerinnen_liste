# app/interactors/contact_form/submit_interactor.rb

module ContactForm
  class SubmitInteractor
    include Interactor

    def call
      message = Message.new(context.params)

      if message.valid?
        if spam_email?(message.email)
          # Pretend success but don't send emails
          context.skip_delivery = true
        else
          send_contact_email(message, context.profile)
          NotificationsMailer.copy_to_sender(message, context.profile.fullname).deliver if context.profile.present?
        end
      else
        context.message = message
        context.fail!(error: error_message(context.profile))
      end
    end

    private

    def spam_email?(email)
      spam_emails.include?(email)
    end

    def spam_emails
      ENV.fetch('FISHY_EMAILS', '').split(',')
    end

    def send_contact_email(message, profile)
      recipient_email = profile&.email || 'team@speakerinnen.org'
      NotificationsMailer.contact_message(message, recipient_email).deliver
    end

    def error_message(profile)
      if profile.present?
        I18n.t(:error, scope: 'contact.form')
      else
        I18n.t(:error_email_for_us, scope: 'contact.form')
      end
    end
  end
end
