require 'spec_helper'

describe LanguageMigrator, type: :model do
  describe '.create_profile_languages' do

    it 'creates ProfileLanguages for German lower case language strings' do
      profile = FactoryGirl.create(:user, languages: "deutsch und englisch")

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ["en", "de"]
    end

    it 'creates ProfileLanguages for languages abbreviations' do
      profile = FactoryGirl.create(:user, languages: "D, EN")

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ["en", "de"]
    end

    it 'creates ProfileLanguages for "Deutsch"' do
      profile = FactoryGirl.create(:user, languages: "Deutsch")

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ["de"]
    end

    it 'Deutsch, Schweizerdeutsch, Englisch, (Französisch, Italienisch)'

    it 'creates ProfileLanguages for "Deutsch, Englisch, Türkisch"' do
      profile = FactoryGirl.create(:user, languages: "Deutsch, Englisch, Türkisch")

      LanguageMigrator.create_profile_languages(profile)
      expect(profile.profile_languages.map(&:iso_639_1)).to match_array ["de", "en", "tr"]
    end
  end
end
