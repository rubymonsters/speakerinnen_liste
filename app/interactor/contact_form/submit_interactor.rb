# app/interactors/contact_form/submit_interactor.rb

module ContactForm
  class SubmitInteractor
    include Interactor

    def call
      context.message = Message.new(context.params)

      if context.message.valid?
        if spam_email?(context.message.email)
          # Pretend success but don't send emails
          context.skip_delivery = true
        else
          send_to_speakerin(context.message, context.profile)
          send_copy_to_sender(context.message) if context.profile.present?
        end
      else
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

    def send_to_speakerin(message, profile)
      recipient = profile&.email || 'team@speakerinnen.org'
      NotificationsMailer.speakerin_message(message, recipient).deliver
    end

    def send_copy_to_sender(message)
      NotificationsMailer.sender_message(message).deliver
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
