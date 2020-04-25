# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  default from: 'team@speakerinnen.org'

  def new_profile_confirmed(profile)
    @profile = profile
    @url = 'https://github.com/rubymonsters/speakerinnen_liste/wiki/Approve-new-Speakerinnen*-so-they-get-published'
    mail(to: 'christiane@speakerinnen.org, maren@speakerinnen.org', subject: 'Publish new Speakerinnen Profile')
  end

  def profile_published(profile)
    @profile = profile
    @url = 'https://www.speakerinnen.org'
    mail(
      to: @profile.email,
      subject: I18n.t('devise.mailer.published.subject')
    )
  end
end
