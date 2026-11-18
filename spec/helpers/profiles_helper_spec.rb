require 'rails_helper'

RSpec.describe ProfilesHelper, type: :helper do
  before { I18n.locale = :en }
  after { I18n.locale = I18n.default_locale }

  describe '#profile_location' do
    it 'joins city and country with a comma' do
      profile = build(:profile, city_en: 'Berlin', country: 'DE')

      expect(helper.profile_location(profile)).to eq('Berlin, Germany')
    end

    it 'shows only the city when no country is given' do
      profile = build(:profile, city_en: 'Berlin', country: nil)

      expect(helper.profile_location(profile)).to eq('Berlin')
    end

    it 'returns nil when neither is given' do
      profile = build(:profile, city_en: nil, country: nil)

      expect(helper.profile_location(profile)).to be_nil
    end
  end

  describe '#profile_languages' do
    it 'joins the languages with a comma' do
      profile = build(:profile, iso_languages: %w[de en fr])

      expect(helper.profile_languages(profile)).to eq('German, English, French')
    end

    it 'returns nil when no languages are given' do
      profile = build(:profile, iso_languages: [])

      expect(helper.profile_languages(profile)).to be_nil
    end
  end

  describe '#profile_websites' do
    it 'returns only the websites in the current language when there are any' do
      profile = build(:profile, website_en: 'en.example.org', website_2_en: '', website_de: 'de.example.org')

      expect(helper.profile_websites(profile)).to eq(['en.example.org'])
    end
  end

  describe '#profile_social_media_links' do
    it 'returns url and icon for filled in networks only' do
      profile = build(:profile, instagram: 'https://instagram.com/ada', mastodon: 'https://chaos.social/@ada')

      expect(helper.profile_social_media_links(profile)).to eq([
        ['https://instagram.com/ada', 'fa-brands fa-instagram'],
        ['https://chaos.social/@ada', 'fa-brands fa-mastodon']
      ])
    end

    it 'adds twitter as an icon' do
      profile = build(:profile, twitter_en: '@ada')

      expect(helper.profile_social_media_links(profile)).to include(['https://twitter.com/ada', 'fa-brands fa-x-twitter'])
    end
  end
end
