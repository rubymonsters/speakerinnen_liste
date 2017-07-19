describe "profile adding" do
  it 'allows to create a profile with languages' do
    # capyara visit method set the locale to :en
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
    find(:css, "#twitter_en").set("@Lovelace")
    find(:css, "#city_en").set("London")

    select "United Kingdom", from: I18n.t(:country, scope: 'activerecord.attributes.profile'), match: :first
    page.check I18n.t(:es, scope: 'iso_639_1').capitalize
    find(:css, "#profile_iso_languages_es").set(true)
    click_button I18n.t(:update, scope: 'profiles.form')
    expect(page).to have_content('Spanish')
  end
end
