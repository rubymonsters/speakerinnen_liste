# app/interactors/contact_form/submit_interactor.rb

module ContactForm
  class SubmitInteractor
    include Interactor

    def call
      message = Message.new(context.params)

      if message.valid?
        if spam_email?(message.email) || contains_forbidden_words?(message)
          # Pretend success but don't send emails
          context.skip_delivery = true
          log_blocked_message(message)
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

    def log_blocked_message(message)
      Rails.logger.warn("Blocked message from: #{message.email}, subject: #{message.subject}")
      BlockedEmail.create!(
        email: message.email,
        subject: message.subject,
        body: message.body
      )
    end

    def contains_forbidden_words?(message)
      text = "#{message.subject} #{message.body}".downcase
      OffensiveTerm.pluck(:word).any? { |word| text.include?(word) }
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
