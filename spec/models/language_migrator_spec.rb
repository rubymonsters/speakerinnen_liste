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

    it 'creates ProfileLanguages for "de;en"' do
      profile = FactoryGirl.create(:profile, languages: 'de;en')

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ['de', 'en']
    end

    it 'creates ProfileLanguages for "Deutsch"' do
      profile = FactoryGirl.create(:profile, languages: 'Deutsch')

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ['de']
    end

    it 'matches languages in brackets' do
      profile = FactoryGirl.create(:profile, languages: 'Deutsch, Englisch, (Französisch, Italienisch)')

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ['de', 'en', 'fr', 'it']
    end

    it 'ignores not known languages' do
      profile = FactoryGirl.create(:profile, languages: 'Deutsch, Schweizerdeutsch')

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ['de']
    end

    it 'creates ProfileLanguages for english languages' do
      profile = FactoryGirl.create(:profile, languages: 'German, English, Spanish')

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ['de', 'en', 'es']
    end

    it 'creates ProfileLanguages for "Deutsch, Englisch, Türkisch"' do
      profile = FactoryGirl.create(:profile, languages: 'Deutsch, Englisch, Türkisch')

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ['de', 'en', 'tr']
    end

#more languages
    it 'creates ProfileLanguages for Francais' do
      profile = FactoryGirl.create(:profile, languages: 'Francais')

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ['fr']
    end

    it 'creates ProfileLanguages for English & German' do
      profile = FactoryGirl.create(:profile, languages: 'English & German')

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ['en', 'de']
    end

    it 'creates ProfileLanguages for Deutsch, Englisch fliessend' do
      profile = FactoryGirl.create(:profile, languages: 'Deutsch, Englisch fliessend')

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ['de', 'en']
    end

    it 'creates ProfileLanguages for Deutsch, English, Español' do
      profile = FactoryGirl.create(:profile, languages: 'Deutsch, English, Español')

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ['de', 'en', 'es']
    end

    it 'creates ProfileLanguages for Englisch; Französisch; Italienisch; Luxemburgisch' do
      profile = FactoryGirl.create(:profile, languages: 'Englisch; Französisch; Italienisch; Luxemburgisch')

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ['fr', 'en', 'it', 'lb']
    end

    it 'creates ProfileLanguages for nil' do
      profile = FactoryGirl.create(:profile, languages: nil)

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to be_empty;
    end

  end
end
