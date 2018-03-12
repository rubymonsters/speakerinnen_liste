include AuthHelper

describe 'profile navigation' do
  let!(:locale_language_de) { FactoryBot.create(:locale_language_de) }
  let!(:locale_language_en) { FactoryBot.create(:locale_language_en) }

  let!(:tag_de) { FactoryBot.create(:tag_chemie, locale_languages: [locale_language_de]) }
  let!(:tag_en) { FactoryBot.create(:tag_physics, locale_languages: [locale_language_en]) }
  let!(:tag_no_lang) { FactoryBot.create(:tag, name: 'math') }

  let!(:ada) do
    FactoryBot.create(:published,
                       firstname: 'Ada',
                       lastname: 'Lovelace',
                       email: 'ada@lovelace.de',
                       twitter: '@alove',
                       main_topic_en: 'first computer programm',
                       bio_en: 'first programmer',
                       main_topic_de: 'Erstes Computer-Programm',
                       bio_de: 'Erste Programmiererin',
                       city: 'London',
                       country: 'GB',
                       iso_languages: %w[en de],
                       topic_list: [tag_de, tag_en, tag_no_lang])
  end

  let!(:ada_medialink) do
    FactoryBot.create(:medialink,
                       profile_id: ada.id,
                       title: 'Ada and the computer',
                       url: 'www.adalovelace.de',
                       description: 'How to programm')
  end

  describe 'show view profile in EN' do
    before do
      sign_in ada
      click_on 'EN', match: :first
    end

    it 'directs after signin to the own profile page' do
      expect(page).to have_content('Ada')
      expect(page).to have_content('Lovelace')
      expect(page).to have_content('@alove')
      expect(page).to have_content('London')
      expect(page).to have_content('United Kingdom')
      expect(page).to have_content('first programmer')
      expect(page).to have_content('first computer programm')
      expect(page).to have_content('physics')
      expect(page).to have_content('math')
      expect(page).to have_content('German')
      expect(page).to have_content('English')
      expect(page).to have_content('Ada and the computer')
      expect(page).to have_content('www.adalovelace.de')
      expect(page).to have_content('How to programm')
    end

    it 'gives the possibility to edit the account information' do
      expect(page).to have_css('#accountSettings')
    end

    it 'shows tags in the correct language' do
      expect(page).to have_content('physics')
      expect(page).not_to have_content('chemie')
    end

    it 'shows tags with no language assigned' do
      expect(page).to have_content('math')
    end
  end

  describe 'show view profile in DE' do
    before do
      sign_in ada
      click_on 'EN', match: :first
      click_on 'DE', match: :first
    end

    it 'directs after signin to the own profile page' do
      expect(page).to have_content('Ada')
      expect(page).to have_content('Lovelace')
      expect(page).to have_content('@alove')
      expect(page).to have_content('London')
      expect(page).to have_content('Vereinigtes Königreich')
      expect(page).to have_content('Erste Programmiererin')
      expect(page).to have_content('Erstes Computer-Programm')
      expect(page).to have_content('chemie')
      expect(page).to have_content('math')
      expect(page).to have_content('Englisch')
      expect(page).to have_content('Deutsch')
      expect(page).to have_content('Ada and the computer')
      expect(page).to have_content('www.adalovelace.de')
      expect(page).to have_content('How to programm')
    end

    it 'gives the possibility to edit the account information' do
      expect(page).to have_css('#accountSettings')
    end

    it 'shows tags in the correct language' do
      expect(page).to have_content('chemie')
      expect(page).not_to have_content('physics')
    end

    it 'shows tags with no language assigned' do
      expect(page).to have_content('math')
    end
  end

  describe 'edit view profile in EN' do
    before do
      sign_in ada
      click_on 'EN', match: :first
      click_on 'Edit profile'
    end

    it 'directs after edit profile to the edit page' do
      expect(page).to have_content('name')
      expect(page).to have_content('twitteraccount')
      expect(page).to have_content('My main topic in German')
    end

    it 'shows the correct tabs and the selected tab' do
      expect(page).to have_css('.selected', text: 'English')
    end

    it 'shows the correct main topic' do
      expect(page).to have_css('.hidden', text: 'My main topic in German')
    end
  end

  describe 'edit view profile in DE' do
    before do
      sign_in ada
      click_on 'EN', match: :first
      click_on 'DE', match: :first
      click_on 'Profil bearbeiten'
    end

    it 'directs after edit profile to the edit page' do
      expect(page).to have_content('Vorname')
      expect(page).to have_content('Twitteraccount')
      expect(page).to have_content('Mein Hauptthema auf Deutsch:')
    end

    it 'shows the correct tabs and the selected tab' do
      expect(page).to have_css('.selected', text: 'Deutsch')
    end

    it 'shows the correct main topic' do
      expect(page).to have_css('.hidden', text: 'Mein Hauptthema auf Englisch')
    end
  end

  describe 'index view profiles in EN' do
    before do
      visit '/en/profiles'
    end

    it 'shows list of all speakers' do
      expect(page).to have_content('Ada')
      expect(page).to have_content('Lovelace')
      expect(page).to have_content('physics')
      expect(page).to have_content('math')
    end

    it 'shows tags in the correct language' do
      expect(page).to have_content('physics')
      expect(page).not_to have_content('chemie')
    end

    it 'shows tags with no language assigned' do
      expect(page).to have_content('math')
    end
  end

  describe 'index view profiles in DE' do
    before do
      visit '/de/profiles'
    end

    it 'shows list of all speakers' do
      expect(page).to have_content('Ada')
      expect(page).to have_content('Lovelace')
      expect(page).to have_content('chemie')
      expect(page).to have_content('math')
    end

    it 'shows tags in the correct language' do
      expect(page).to have_content('chemie')
      expect(page).not_to have_content('physics')
    end

    it 'shows tags with no language assigned' do
      expect(page).to have_content('math')
    end
  end
end
