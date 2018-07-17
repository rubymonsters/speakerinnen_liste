RSpec.describe 'Localization', type: :system do
  it 'start page localization' do
    visit root_path

    within '#nav__lap-and-up' do
      click_link 'DE'
    end

    expect(page).to have_link('Einloggen')
    expect(page).to have_button('Suche')

    within '#nav__lap-and-up' do
      click_link 'EN'
    end

    expect(page).to have_link('Log in')
    expect(page).to have_button('Search')
  end
end
