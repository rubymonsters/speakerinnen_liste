RSpec.feature 'Login', type: :feature do
  before do
    FactoryBot.create(:published_profile, email: 'ada@mail.de' )
    page.driver.browser.set_cookie("cookie_consent=true")
  end

  it 'login with correct password' do
    visit '/de'
    expect(page).to have_content('Einloggen')
    click_link('Einloggen')

    fill_in('profile[email]', with: 'ada@mail.de')
    fill_in('profile[password]', with: '123foobar')
    click_button 'Anmelden'

    expect(page).to have_content('Erfolgreich angemeldet.')
  end

  it 'doesnt login with wrong password' do
    visit '/de'
    expect(page).to have_content('Einloggen')
    click_link('Einloggen')

    fill_in('profile[email]', with: 'ada@mail.de')
    fill_in('profile[password]', with: 'wrongpassword')
    click_button 'Anmelden'

    expect(page).to have_content('Ungültige Anmeldedaten.')
  end
end
