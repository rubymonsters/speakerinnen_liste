# frozen_string_literal: true

describe 'profile adding' do
  it 'allows to create a profile with languages', js: true do
    visit root_path(locale: :de)
    click_on I18n.t(:allow_cookies, scope: 'pages.home')

    find('a', text: I18n.t(:signup, scope: 'layouts.application'), visible: :all).trigger(:click)
    fill_in 'E-Mail', with: 'test@test.de'
    fill_in 'profile_password', with: '12345678'
    fill_in 'profile_password_confirmation', with: '12345678'
    click_button I18n.t(:signup, scope: 'devise.registrations')
    expect(page).to have_css('div.alert', text: I18n.t(:signed_up_but_unconfirmed, scope: 'devise.registrations'))
    Profile.last.confirm

    find('a', text: I18n.t(:login, scope: 'layouts.application'), visible: :all).trigger(:click)
    fill_in 'E-Mail', with: 'test@test.de'
    fill_in 'profile_password', with: '12345678'
    click_button I18n.t(:signin, scope: 'devise.registrations')

    click_link I18n.t(:edit, scope: 'profiles.show')

    fill_in I18n.t(:firstname, scope: 'profiles.form'), with: 'Ada'
    fill_in I18n.t(:lastname, scope: 'profiles.form'), with: 'Lovelace'

    find(:css, '#profile_twitter_de').set('@liebe')
    find(:css, '#profile_city_de').set('Graz')
    find(:css, '#profile_website_de').set('www.adalovelace.de')
    find(:css, '#profile_website_2_de').set('www.mariecurie.de')
    find(:css, '#profile_website_3_de').set('www.marthanussbaum.de')
    find(:css, '#profile_profession_de').set('Mathematisches Genie')

    click_on 'Englisch'
    find(:css, '#profile_twitter_en').set('@Lovelace')
    find(:css, '#profile_city_en').set('Graz')
    find(:css, '#profile_website_en').set('www.adalovelace.org')
    find(:css, '#profile_profession_en').set('Mathematics Genius')
    find(:css, '#profile_website_2_en').set('www.mariecurie.org')
    find(:css, '#profile_website_3_en').set('www.marthanussbaum.org')

    select 'Bitte auswählen', from: I18n.t(:country, scope: 'profiles.form')
    select 'Österreich', from: I18n.t(:country, scope: 'profiles.form'), match: :first

    select 'Bitte auswählen', from: I18n.t(:"state.at")
    select 'Steiermark', from: I18n.t(:"state.at"), wait: :true

    find(:css, '#profile_iso_languages_en').set(true)
    find(:css, '#profile_iso_languages_de').set(true)

    click_button I18n.t(:update, scope: 'profiles.form')

    expect(page).to have_content('Ada')
    expect(page).to have_content('Lovelace')
    expect(page).to have_content('Mathematisches Genie')
    expect(page).to have_content('Englisch')
    expect(page).to have_content('Deutsch')
    expect(page).to have_content('Graz')
    expect(page).to have_content('Steiermark')
    expect(page).to have_content('Österreich')
    expect(page).to have_content('www.adalovelace.de')
    expect(page).to have_content('www.mariecurie.de')
    expect(page).to have_content('www.marthanussbaum.de')
    expect(page).to have_content('@liebe')

    find('a', text: 'EN', visible: :all).trigger(:click)
    
    expect(page).to have_content('Ada')
    expect(page).to have_content('Lovelace')
    expect(page).to have_content('Mathematics Genius')
    expect(page).to have_content('English')
    expect(page).to have_content('German')
    expect(page).to have_content('Graz')
    expect(page).to have_content('Styria')
    expect(page).to have_content('Austria')
    expect(page).to have_content('www.adalovelace.org')
    expect(page).to have_content('www.mariecurie.org')
    expect(page).to have_content('www.marthanussbaum.org')
    expect(page).to have_content('@Lovelace')
  end
end
