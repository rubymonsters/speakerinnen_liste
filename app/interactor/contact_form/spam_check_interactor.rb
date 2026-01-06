# app/interactors/contact_form/spam_check_interactor.rb
module ContactForm
  class SpamCheckInteractor
    include Interactor

    def call
      message = context.message

      if spam?(message)
        context.spam = true
        context.reason = reason(message)
      else
        context.spam = false
      end
    end

    private

    # ---------- main decision ----------

    def spam?(message)
      spam_email?(message.email) ||
        offensive_terms?(message) ||
        suspicious_text?(message)
    end

    def reason(message)
      return 'Spam email'        if spam_email?(message.email)
      return 'Offensive content' if offensive_terms?(message)
      return 'Suspicious content' if suspicious_text?(message)

      nil
    end

    # ---------- checks ----------

    def spam_email?(email)
      spam_emails.include?(email)
    end

    def offensive_terms?(message)
      text = combined_text(message)

      offensive_terms.any? do |term|
        text.match?(/\b#{Regexp.escape(term.downcase)}\b/)
      end
    end

    def suspicious_text?(message)
      suspicious_subject?(message.subject) ||
        suspicious_body?(message.body)
    end

    # ---------- helpers ----------

    def suspicious_subject?(subject)
      # must contain some vowels
      return true if subject.count('aeiouAEIOU') < 1

      false
    end

    def suspicious_body?(body)
      # must contain some vowels
      return true if body.count('aeiouAEIOU') < 1

      # must contain at least TWO real words (3+ letters)
      words = body.scan(/\b[a-z]{3,}\b/i)
      return true if words.size < 2

      false
    end

    def combined_text(message)
      "#{message.subject} #{message.body}".downcase
    end

    def spam_emails
      ENV.fetch('FISHY_EMAILS', '').split(',')
    end

    def offensive_terms
      @offensive_terms ||= OffensiveTerm.pluck(:word)
    end
  end
end
