describe 'profile adding' do
  it 'allows to create a profile with languages' do
    visit root_path
    click_link I18n.t(:signup, scope: 'layouts.application')
    fill_in 'E-Mail', with: 'test@test.de'
    fill_in 'profile_password', with: '12345678'
    fill_in 'profile_password_confirmation', with: '12345678'
    click_button I18n.t(:signup, scope: "devise.registrations")

    Profile.last.confirm!

    click_link I18n.t(:login, scope: 'layouts.application')
    fill_in 'E-Mail', with: 'test@test.de'
    fill_in 'profile_password', with: '12345678'
    click_button I18n.t(:signin, scope: "devise.registrations")

    click_link I18n.t(:edit, scope: 'profiles.profile')
    fill_in I18n.t(:firstname, scope: 'activerecord.attributes.profile'), with: 'Ada'
    fill_in I18n.t(:lastname, scope: 'activerecord.attributes.profile'), with: 'Lovelace'
    fill_in I18n.t(:twitter, scope: 'activerecord.attributes.profile'), with: '@Lovelace'
    fill_in I18n.t(:city, scope: 'activerecord.attributes.profile'), with: 'London'
    select LanguageList::LanguageInfo.find('af').name, from: I18n.t(:language, scope: 'profiles.index')
    select LanguageList::LanguageInfo.find('ar').name, from: I18n.t(:language, scope: 'profiles.index')
    click_button I18n.t(:update, scope: 'profiles.form')

    expect(page).to have_content('Arabisch')
    expect(page).to have_content('Afrikaans')
  end
end
