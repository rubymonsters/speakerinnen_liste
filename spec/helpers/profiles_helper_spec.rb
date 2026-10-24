require 'rails_helper'

RSpec.describe ProfilesHelper, type: :helper do
  before { I18n.locale = :en }
  after { I18n.locale = I18n.default_locale }

  describe '#profile_intro' do
    it 'joins city and languages with a dot' do
      profile = build(:profile, city_en: 'Berlin', iso_languages: %w[en de])

      expect(helper.profile_intro(profile))
        .to eq('<strong>Berlin</strong> · <strong>English</strong> and <strong>German</strong>')
    end

    it 'shows only the city when no languages are given' do
      profile = build(:profile, city_en: 'Berlin', iso_languages: [])

      expect(helper.profile_intro(profile)).to eq('<strong>Berlin</strong>')
    end

    it 'shows only the languages when no city is given' do
      profile = build(:profile, city_en: nil, iso_languages: %w[en])

      expect(helper.profile_intro(profile)).to eq('<strong>English</strong>')
    end

    it 'returns nil when neither is given' do
      profile = build(:profile, city_en: nil, iso_languages: [])

      expect(helper.profile_intro(profile)).to be_nil
    end

    it 'escapes the city' do
      profile = build(:profile, city_en: '<b>Berlin</b>', iso_languages: [])

      expect(helper.profile_intro(profile)).to include('&lt;b&gt;Berlin&lt;/b&gt;')
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
  end
end
