# frozen_string_literal: true

describe 'Changing the language' do
  let!(:ada) { FactoryBot.create(:ada) }

  it 'stays on start page' do
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

  it 'stays on profile page' do
    visit profile_path(id: ada.id)
    expect(page).to have_content('Contact Ada')

    within '#DropdownLanguages' do
      click_link 'DE'
    end

    expect(page).to have_content('Kontaktiere Ada')
  end

  it 'keeps search results' do
    visit profiles_path(search: 'Marie')
    expect(page).to have_content('Marie')

    within '#DropdownLanguages' do
      click_link 'DE'
    end

    expect(page).to have_content('Marie')
  end
end
