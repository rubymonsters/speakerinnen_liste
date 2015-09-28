require 'spec_helper'

describe 'profile adding' do
  it 'allows to create a profile with languages' do
    visit root_path
    click_link 'registrieren'
    fill_in 'E-Mail', with: 'test@test.de'
    fill_in 'profile_password', with: '12345678'
    fill_in 'profile_password_confirmation', with: '12345678'
    click_button 'Registrieren'

    Profile.last.confirm!

    click_link 'Anmelden'
    fill_in 'E-Mail', with: 'test@test.de'
    fill_in 'profile_password', with: '12345678'
    click_button 'Anmelden'

    click_link 'Profil'
    click_link 'Profil bearbeiten'
    fill_in 'Vorname', with: 'Ada'
    fill_in 'Nachname', with: 'Lovelace'
    fill_in 'Twitter', with: '@Lovelace'
    fill_in 'Stadt', with: 'London'
    select 'Arabisch', from: 'Sprache'
    select 'Afrikaans', from: 'Sprache'
    click_button 'Aktualisiere'

    expect(page).to have_content('Arabisch')
    expect(page).to have_content('Afrikaans')


    save_and_open_page
  end
end
