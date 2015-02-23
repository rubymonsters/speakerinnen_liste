require 'spec_helper'

describe 'profile search' do
  let!(:profile) { FactoryGirl.create(:published, firstname: 'Horstine', lastname: 'Schmidt', city: 'Berlin', twitter: 'Apfel') }
  let!(:profile_language_de) { ProfileLanguage.create!(profile: profile, iso_639_1: 'de') }
  let!(:profile_language_es) { ProfileLanguage.create!(profile: profile, iso_639_1: 'es') }

  let!(:profile_not_matched) { FactoryGirl.create(:published, firstname: 'Claudia', email: 'claudia@test.de', city: 'Warschau', twitter: 'Birne' ) }

  describe 'quick search' do
    it 'displays profiles that are a partial match' do
      visit root_path
      fill_in 'search-field', with: 'Horstin'
      click_button 'Suche'
      expect(page).to have_content('Horstine')
    end
  end

  describe 'detailed search' do

    before do
      visit profiles_path
    end

    it 'displays profiles partial match for city' do
      within '#detailed-search' do
        fill_in 'Stadt', with: 'Berli'
        click_button 'Suche'
      end
      expect(page).to have_content('Horstine')
    end

    it 'displays profiles that match any of the selected languages' do
      within '#detailed-search' do
        select 'Spanisch'
        select 'Deutsch'
        click_button 'Suche'
      end
      expect(page).to have_content('Horstine')
    end

    it 'displays profiles partial match for name' do
      within '#detailed-search' do
        fill_in 'Name', with: 'Schmidt'
        click_button 'Suche'
      end
      expect(page).to have_content('Horstine')
    end

    it 'displays profiles partial match for twitter' do
      within '#detailed-search' do
        fill_in 'Twitter', with: 'Apfe'
        click_button 'Suche'
      end
      expect(page).to have_content('Horstine')
    end

    it 'displays profiles partial match for topic' do
      profile.topic_list.add("obst")
      profile.save!

      visit profiles_path
      within '#detailed-search' do
        fill_in 'Themen', with: 'Obst'
        click_button 'Suche'
      end
      expect(page).to have_content('Horstine')
    end

  end
end
