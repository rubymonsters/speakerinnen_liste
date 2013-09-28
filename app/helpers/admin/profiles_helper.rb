module Admin::ProfilesHelper
  def name_or_email(profile)
    if profile.fullname.present?
      profile.fullname
    else
      profile.email
    end
  end
end
