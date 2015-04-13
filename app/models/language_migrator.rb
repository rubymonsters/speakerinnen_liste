class LanguageMigrator

  def self.create_profile_languages(profiles)
    Array(profiles).each do |profile|
      #if profile.languages.match(/[D,d]eutsch|D/)
        #ProfileLanguage.create!(profile: profile, iso_639_1: "de")
      #end
      #if profile.languages.match(/[E,e]nglisch|EN/)
        #ProfileLanguage.create!(profile: profile, iso_639_1: "en")
      #end
      #if profile.languages.match(/Türkisch/)
        #ProfileLanguage.create!(profile: profile, iso_639_1: "tr")
      #end

      I18n.t('iso_639_1').each do |iso_code, language|
        if profile.languages.match(/#{language}|#{iso_code}[\,\s\$]/i)
          ProfileLanguage.create!(profile: profile, iso_639_1: iso_code)
        end
      end
    end

  end

end
