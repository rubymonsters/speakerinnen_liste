# app/interactors/contact_form/submit_interactor.rb

module ContactForm
  class SubmitInteractor
    include Interactor

    def call
      message = Message.new(context.params)

      if message.valid?
        if spam_email?(message.email) || contains_exactly_forbidden_terms?(message)
          # Pretend success but don't send emails
          context.skip_delivery = true
          log_blocked_message(message)
        else
          send_contact_email(message, context.profile)
          NotificationsMailer.copy_to_sender(message, context.profile.fullname).deliver_now if context.profile.present?
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
      NotificationsMailer.contact_message(message, recipient_email).deliver_now
    end

    def log_blocked_message(message)
      puts "Blocked message from: #{message.email}, subject: #{message.subject} message: #{message.body}  "
      Rails.logger.warn("Blocked message from: #{message.email}, subject: #{message.subject}")
      BlockedEmail.create!(
        name: message.name,
        email: message.email,
        subject: message.subject,
        body: message.body,
        reason: 'Offensive content'
      )
    end

    def contains_exactly_forbidden_terms?(message)
      # combine subject and body, downcase everything
      text = "#{message.subject} #{message.body}".downcase

      # check if any forbidden term appears as a whole word
      OffensiveTerm.pluck(:word).any? do |term|
        pattern = /\b#{Regexp.escape(term.downcase)}\b/
        text.match?(pattern)
      end
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
