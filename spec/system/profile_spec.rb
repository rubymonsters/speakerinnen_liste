# frozen_string_literal: true

describe 'profile navigation' do
  include AuthHelper

  let!(:locale_language_de) { create(:locale_language_de) }
  let!(:locale_language_en) { create(:locale_language_en) }

  let!(:tag_de) { create(:tag_chemie, locale_languages: [locale_language_de]) }
  let!(:tag_en) { create(:tag_physics, locale_languages: [locale_language_en]) }
  let!(:tag_no_lang) { create(:tag, name: 'writer') }

  let!(:ada) { create(:ada, topic_list: [tag_de, tag_en, tag_no_lang]) }
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
      expect(page).to have_content('Carinthia')
      expect(page).to have_content('Austria')
      expect(page).to have_content('She published the first algorithm for a machine.')
      expect(page).to have_content('math')
      expect(page).to have_content('physics')
      expect(page).to have_content('writer')
      expect(page).to have_content('German')
      expect(page).to have_content('English')
      expect(page).to have_link('Ada and the computer', href: 'https://www.adalovelace.de')
      expect(page).to have_content('www.ada.de')
      expect(page).to have_content('www.ada2.de')
      expect(page).to have_content('www.ada3.de')
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
      expect(page).to have_content('Kärnten')
      expect(page).to have_content('Österreich')
      expect(page).to have_content('Sie hat den ersten Algorithmus veröffentlicht.')
      expect(page).to have_content('Mathematik')
      expect(page).to have_content('chemie')
      expect(page).to have_content('writer')
      expect(page).to have_content('Englisch')
      expect(page).to have_content('Deutsch')
      expect(page).to have_link('Ada and the computer', href: 'https://www.adalovelace.de')
      expect(page).to have_content('www.ada.de')
      expect(page).to have_content('www.ada2.de')
      expect(page).to have_content('www.ada3.de')
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
      expect(page).to have_content('writer')
    end
  end

  describe 'globalize fall-back options for websites' do
    before do
      sign_in ada
      click_on 'EN', match: :first
    end

    it 'when there is no website given for the current language scope you are in use the fall-back' do
      expect(page).to have_content('www.ada.de')
      expect(page).to have_content('www.ada2.de')
      expect(page).to have_content('www.ada3.de')
      click_on 'DE', match: :first
      expect(page).to have_content('www.ada.de')
      expect(page).to have_content('www.ada2.de')
      expect(page).to have_content('www.ada3.de')
    end

    it 'when there is at least one website given for the current language dont use fall-back' do
      ada.website_en = 'www.ada.en'
      ada.website_2_en = 'www.ada2.en'
      ada.save!
      visit current_path
      expect(page).to have_content('www.ada.en')
      expect(page).to have_content('www.ada2.en')
      expect(page).not_to have_content('www.ada3.de')
      click_on 'DE', match: :first
      expect(page).to have_content('www.ada.de')
      expect(page).to have_content('www.ada2.de')
      expect(page).to have_content('www.ada3.de')
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
      expect(page).to have_content('Twitteraccount')
    end

    it 'shows the correct tabs and the selected tab' do
      expect(page).to have_css('.active', text: 'English')
    end

    it 'shows the correct main topic' do
      expect(page).to have_css('.d-none #main_topic_de')
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
    end

    it 'shows the correct tabs and the selected tab' do
      expect(page).to have_css('.active', text: 'Deutsch')
    end

    it 'shows the correct main topic' do
      expect(page).to have_css('.d-none #main_topic_en')
    end
  end

  describe 'index view profiles in EN' do
    before do
      visit '/en/profiles'
    end

    it 'shows list of all speakers' do
      expect(page).to have_content('Ada')
      expect(page).to have_content('Lovelace')
      expect(page).to have_content('math wiz')
    end

    it 'shows tags in the correct language' do
      expect(page).not_to have_content('Mathematik Genie')
    end

  end

  describe 'index view profiles in DE' do
    before do
      visit '/de/profiles'
    end

    it 'shows list of all speakers with name and main topic' do
      expect(page).to have_content('Ada')
      expect(page).to have_content('Lovelace')
      expect(page).to have_content('Mathematik Genie')
    end

    it 'shows tags in the correct language' do
      expect(page).not_to have_content('math wiz')
    end

  end
end
