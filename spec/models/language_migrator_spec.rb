require 'spec_helper'

describe LanguageMigrator, type: :model do
  describe '.create_profile_languages' do

    it 'creates ProfileLanguages for German lower case language strings' do
      profile = FactoryGirl.create(:profile, languages: 'deutsch und englisch')

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ['en', 'de']
    end

    it 'creates ProfileLanguages for languages abbreviations' do
      profile = FactoryGirl.create(:profile, languages: 'D, EN')

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ['en', 'de']
    end

    it 'creates ProfileLanguages for "Deutsch"' do
      profile = FactoryGirl.create(:profile, languages: 'Deutsch')

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ['de']
    end

    it 'ignores the languages and notes in brackets' do
      profile = FactoryGirl.create(:profile, languages: 'Deutsch, Englisch, (Französisch, Italienisch)')

      LanguageMigrator.create_profile_languages(profile)
      pending("not yet implemented")
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ['de', 'en']
    end

    it 'ignores not known languages' do
      profile = FactoryGirl.create(:profile, languages: 'Deutsch, Schweizerdeutsch')

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ['de']
    end

    it 'creates ProfileLanguages for english languages' do
      profile = FactoryGirl.create(:profile, languages: 'German, English, Spanish')

      LanguageMigrator.create_profile_languages(profile)
      pending("not yet implemented")
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ['de', 'en', 'sp']
    end

    it 'creates ProfileLanguages for "Deutsch, Englisch, Türkisch"' do
      profile = FactoryGirl.create(:profile, languages: 'Deutsch, Englisch, Türkisch')

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ['de', 'en', 'tr']
    end
  end
end
