# frozen_string_literal: true

RSpec.feature 'Localization', type: :feature do
  scenario 'start page localization' do
    visit root_path

    within '#DropdownLanguages' do
      click_link 'DE'
    end

    expect(page).to have_link('Einloggen')
    expect(page).to have_button('Suche')

    within '#DropdownLanguages' do
      click_link 'EN'
    end

    expect(page).to have_link('Log in')
    expect(page).to have_button('Search')
  end
end
