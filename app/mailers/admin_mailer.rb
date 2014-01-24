class AdminMailer < ActionMailer::Base
  default :from => "speakerInnen@gmail.com"

  def new_profile_confirmed(profile)
    @profile = profile
    @url  = 'https://github.com/rubymonsters/speakerinnen_liste/wiki/Approve-new-Speakerinnen*-so-they-get-published'
    mail(to: 'tyranja@cassiopeia.uberspace.de', subject: 'Publish new Speakerinnen Profile')
  end

  def profile_published(profile)
    @profile = profile
    mail(to: @profile.email, subject: 'Your are now pulished on the Speakerinnen Website')
  end

end
