require 'spec_helper'

describe 'profile search' do
  let!(:profile) { FactoryGirl.create(:published, firstname: 'Horstine', city: 'Berlin') }

  describe 'quick search' do
    it 'displays profiles that are a partial match' do
      visit root_path
      fill_in 'search-field', with: 'Horstin'
      click_button 'Suche'
      expect(page).to have_content('Horstine')
    end
  end

  describe 'detailed search' do
    it 'displays profiles partial match for city' do
      visit profiles_path
      within '#detailed-search' do
        fill_in 'Stadt', with: 'Berli'
        click_button 'Suche'
      end
      expect(page).to have_content('Horstine')
    end
  end

end

