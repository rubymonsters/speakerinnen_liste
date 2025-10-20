# frozen_string_literal: true

RSpec.feature 'Editing a profile', type: :system do
  context 'logged in as an admin' do
    let(:admin) { create(:profile, :admin) }
    let!(:user) { create(:published_profile) }

    before do
      sign_in admin
    end

    scenario 'profile editing' do
      visit admin_profiles_path

      click_link 'Edit', match: :first

      fill_in I18n.t(:firstname, scope: 'profiles.form'), with: 'Ada'
      fill_in I18n.t(:lastname, scope: 'profiles.form'), with: 'Lovelace'
      find(:css, '#profile_city_en').set('Vienna')
      find(:css, '#profile_website_en').set('www.adalovelace.org')
      find(:css, '#profile_website_2_en').set('www.mariecurie.org')
      find(:css, '#profile_website_3_en').set('www.marthanussbaum.org')
      find(:css, '#profile_city_de').set('Wien')
      find(:css, '#profile_website_de').set('www.adalovelace.de')
      find(:css, '#profile_website_2_de').set('www.mariecurie.de')
      find(:css, '#profile_website_3_de').set('www.marthanussbaum.de')
      select 'Austria', from: I18n.t(:country, scope: 'profiles.form'), match: :first
      find(:css, '#profile_iso_languages_en').set(true)
      find(:css, '#profile_iso_languages_de').set(true)

      click_button I18n.t(:update, scope: 'profiles.form')

      expect(page).to have_content('Ada')
      expect(page).to have_content('Lovelace')
      expect(page).to have_content('English')
      expect(page).to have_content('German')
      expect(page).to have_content('Vienna')
      expect(page).to have_content('Austria')
      expect(page).to have_content('www.adalovelace.org')
      expect(page).to have_content('www.mariecurie.org')
      expect(page).to have_content('www.marthanussbaum.org')
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
    end
  end
end
