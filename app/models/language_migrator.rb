class LanguageMigrator

  def self.create_profile_languages(profiles)
    [:en, :de].each do |locale|
      I18n.locale = locale
      Array(profiles).each do |profile|
        I18n.t('iso_639_1').each do |iso_code, language|
          if !language_exists?(profile, iso_code) && language_matches?(profile, language, iso_code)
            ProfileLanguage.create!(profile: profile, iso_639_1: iso_code)
          end
        end
      end
    end

  end

  private

  def self.language_matches?(profile, language, iso_code)
    profile.languages.to_s.match(/#{language}|(\W|\A)#{iso_code}(\W|\z)|#{custom_matcher(iso_code)}/i)
  end

  def self.language_exists?(profile, iso_code)
    ProfileLanguage.find_by(profile: profile, iso_639_1: iso_code).present?
  end

  def self.custom_matcher(iso_code)
    match_hash = Hash.new(/\d{5}/)
    match_hash.merge!({ de: /^D\,/, fr: /^F\,|Francais/, es: /Español/ })
    match_hash[iso_code]
  end
end
