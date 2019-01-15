# frozen_string_literal: true

RSpec.describe 'Navigation', type: :system do
  context 'normal visitor' do
    before do
      FactoryBot.create(:published, firstname: 'Emily', lastname: 'Roebling',
                                    main_topic_en: 'engineer', city_en: 'Trenton', iso_languages: ['en'])
      FactoryBot.create(:published, main_topic_en: 'technican')
      FactoryBot.create(:cat_science)
      page.driver.browser.set_cookie('cookie_consent=true')
    end

    it 'startpage has header' do
      visit root_path

      expect(page).to have_css('#header__logo')
      expect(page).to have_link('Register as a speaker')
      expect(page).to have_link('Log in')
      expect(page).to have_link('DE')
    end

    it 'startpage has content' do
      visit root_path

      expect(page).to have_css('#startpage__start-teaser')
      expect(page).to have_css('#startpage__teaser-bg-01')
      expect(page).to have_css('#startpage__teaser-bg-02')
      expect(page).to have_css('.profile-box', text: 'engineer')
      expect(page).to have_css('.profile-box', text: 'technican')
      expect(page).to have_css('.startpage-categories__list-links', count: 1)
      expect(page).to have_link('Science')
    end

    it 'startpage has footer' do
      visit root_path

      expect(page).to have_css('#main-page-footer')
      expect(page).to have_link('Twitter')
      expect(page).to have_link('Email')
      expect(page).to have_link('About us')
    end

    it 'viewing the contact page' do
      visit root_path

      click_link 'Email'
      expect(page).to have_css('form label', text: 'Your name')
      expect(page).to have_css('form label', text: 'Your email address')
      expect(page).to have_css('form label', text: 'Subject')
      expect(page).to have_css('form label', text: 'Your message')

      expect(page).to have_button('Send')
    end

    it 'viewing the speakerinnen overview page' do
      visit root_path

      click_link 'Browse all profiles >>'
      # header
      expect(page).to have_css('#header__logo')
      expect(page).to have_link('Register as a speaker')
      # search
      expect(page).to have_css('input.profile__search')
      expect(page).to have_button('Search')
      # profile
      expect(page).to have_link('Emily Roebling')
      expect(page).to have_css('.profile-card', count: 2)
      expect(page).to have_css('.profile-subtitle', text: 'engineer')
      expect(page).to have_text('English')
      # tag_cloud
      expect(page).to have_css('.topics-cloud')
      # link t profile
      expect(page).to have_link('To the profile')
    end

    it 'viewing a single speakerin page' do
      visit root_path

      click_link 'Browse all profiles >>'
      click_link 'Emily Roebling'
      # header
      expect(page).to have_css('#header__logo')
      expect(page).to have_link('Register as a speaker')
      # navi links
      expect(page).to have_link('Show all women speakers >>')
      # profile
      expect(page).to have_css('.profile-page')
      expect(page).to have_css('.profile-subtitle', text: 'engineer')
      expect(page).to have_text('Trenton')
      expect(page).to have_text('English')
    end
  end

  context 'logged in' do
    context 'as an unprivileged user' do
      let(:user) { FactoryBot.create(:profile) }

      before do
        sign_in user
      end

      it 'shows no admin link' do
        visit root_path

        expect(page).to_not have_link('Admin')
      end

      it 'page has header' do
        visit root_path

        expect(page).to have_css('#header__logo')
        expect(page).to have_link('My profile')
        expect(page).to have_link('Log out')
        expect(page).to have_link('DE')
      end
    end

    context 'as an admin user' do
      let(:admin) { FactoryBot.create(:admin) }

      before do
        sign_in admin
      end

      it 'shows admin link' do
        visit root_path

        expect(page).to have_link('Admin')
      end

      it 'page has header' do
        visit root_path

        expect(page).to have_css('#header__logo')
        expect(page).to have_link('My profile')
        expect(page).to have_link('Log out')
        expect(page).to have_link('DE')
      end
    end
  end

  describe 'logging in' do
    context 'registered user' do
      before do
        FactoryBot.create(:profile, email: 'ltest@exp.com', password: 'rightpassword', password_confirmation: 'rightpassword')
        page.driver.browser.set_cookie('cookie_consent=true')
      end

      it 'successful login' do
        visit new_profile_session_path

        fill_in 'profile_email', with: 'ltest@exp.com'
        fill_in 'profile_password', with: 'rightpassword'

        click_button 'Sign in'

        expect(page).to have_css('.notice', text: 'Logged in successfully.')
      end

      it 'wrong password' do
        visit new_profile_session_path

        fill_in 'profile_email', with: 'ltest@exp.com'
        fill_in 'profile_password', with: 'wrongpassword'

        click_button 'Sign in'

        expect(page).to have_css('.alert', text: 'Invalid email or password.')
      end

      it 'empty password' do
        visit new_profile_session_path

        fill_in 'profile_email', with: 'ltest@exp.com'
        fill_in 'profile_password', with: ''

        click_button 'Sign in'

        expect(page).to have_css('.alert', text: 'Invalid email or password.')
      end

      it 'non-existing email' do
        visit new_profile_session_path

        fill_in 'profile_email', with: 'false@exp.com'
        fill_in 'profile_password', with: 'rightpassword'

        click_button 'Sign in'

        expect(page).to have_css('.alert', text: 'Invalid email or password.')
      end

      it 'empty email' do
        visit new_profile_session_path

        fill_in 'profile_email', with: ''
        fill_in 'profile_password', with: 'rightpassword'

        click_button 'Sign in'

        expect(page).to have_css('.alert', text: 'Invalid email or password.')
      end
    end
  end
end
