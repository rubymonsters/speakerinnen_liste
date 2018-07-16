# frozen_string_literal: true

RSpec.feature 'Editing', type: :feature do
  context 'logged in as an admin' do
    let!(:admin) { create(:admin) }
    let!(:user) { create(:published) }

    before do
      sign_in admin
    end

    scenario 'profile editing' do
      visit admin_profiles_path

      click_link 'Edit', match: :first
      expect(page).to have_text('Administration::Profiles::Edit')
      expect(page).to have_button('Update your profile')
      expect(page).to have_link('Show profile')
      expect(page).to have_link('List all profiles')

      fill_in I18n.t(:firstname, scope: 'activerecord.attributes.profile'), with: 'Ada'
      fill_in I18n.t(:lastname, scope: 'activerecord.attributes.profile'), with: 'Lovelace'
      find(:css, '#profile_twitter_en').set('@Lovelace')
      find(:css, '#profile_city_en').set('Vienna')
      find(:css, '#profile_website_en').set('www.adalovelace.org')
      find(:css, '#profile_website_2_en').set('www.mariecurie.org')
      find(:css, '#profile_website_3_en').set('www.marthanussbaum.org')
      find(:css, '#profile_twitter_de').set('@liebe')
      find(:css, '#profile_city_de').set('Wien')
      find(:css, '#profile_website_de').set('www.adalovelace.de')
      find(:css, '#profile_website_2_de').set('www.mariecurie.de')
      find(:css, '#profile_website_3_de').set('www.marthanussbaum.de')
      select 'Austria', from: I18n.t(:country, scope: 'activerecord.attributes.profile'), match: :first
      find(:css, '#profile_iso_languages_en').set(true)
      find(:css, '#profile_iso_languages_de').set(true)

      click_button I18n.t(:update, scope: 'profiles.form')

      expect(page).to have_content('Ada')
      expect(page).to have_content('Lovelace')
      expect(page).to have_content('English')
      expect(page).to have_content('German')
      expect(page).to have_content('Vienna')
      save_and_open_page
      expect(page).to have_content('Austria')
      expect(page).to have_content('www.adalovelace.org')
      expect(page).to have_content('www.mariecurie.org')
      expect(page).to have_content('www.marthanussbaum.org')
      expect(page).to have_content('@Lovelace')
      click_link('DE', match: :first)
      expect(page).to have_content('Ada')
      expect(page).to have_content('Lovelace')
      expect(page).to have_content('Englisch')
      expect(page).to have_content('Deutsch')
      expect(page).to have_content('Wien')
      expect(page).to have_content('Österreich')
      expect(page).to have_content('www.adalovelace.de')
      expect(page).to have_content('www.mariecurie.de')
      expect(page).to have_content('www.marthanussbaum.de')
      expect(page).to have_content('@liebe')
    end
  end
end
