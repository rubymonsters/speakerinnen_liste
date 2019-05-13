# frozen_string_literal: true

RSpec.describe 'Navigation', type: :system do
  let!(:published_profile) { create(:published_profile, main_topic_en: 'climate', main_topic_de: 'Klima') }
  let!(:ada) { create(:ada) }
  let!(:science) { create(:cat_science) }

  before do
    @lang_links_map = {
      'en' => %w[Categories Tags Profiles Featured Profiles],
      'de' => %w[Kategorien Tags Profile Featured Profiles]
    }
    page.driver.browser.set_cookie("cookie_consent=true")
  end

  %w[en de].each do |language|
    context "in language: #{language}" do
      context 'normal visitor' do
        before { visit "#{language}" }

        it 'startpage has header' do
          expect(page).to have_css('#header__logo')
          expect(page).to have_link(I18n.t('layouts.application.signup'))
          expect(page).to have_link(I18n.t('layouts.application.login'))
          expect(page).to have_link('DE')
          expect(page).to have_link('EN')
          expect(page).to have_no_link('Admin')
        end

        it 'startpage has content' do
          expect(page).to have_css('#startpage__start-teaser')
          expect(page).to have_css('#startpage__teaser-bg-01')
          expect(page).to have_css('#startpage__teaser-bg-02')
          expect(page).to have_css('.profile-box', text: published_profile.main_topic)
          expect(page).to have_css('.profile-box', text: ada.main_topic)
          expect(page).to have_css('.category_item_science', count: 1)
          expect(page).to have_link(science.name)
        end

        it 'startpage has footer' do
          expect(page).to have_css('#main-page-footer')
          expect(page).to have_link('Twitter')
          expect(page).to have_link(I18n.t(:contact_link, scope: 'pages.home.footer'))
          expect(page).to have_link(I18n.t(:about_title, scope: 'pages.home.footer'))
        end

        it 'viewing the contact page' do
          click_link I18n.t(:contact_link, scope: 'pages.home.footer')
          expect(page).to have_css('form label', text: I18n.t(:name, scope: 'contact.form'))
          expect(page).to have_css('form label', text: I18n.t(:email, scope: 'contact.form'))
          expect(page).to have_css('form label', text: I18n.t(:body, scope: 'contact.form'))
          expect(page).to have_css('form label', text: I18n.t(:subject, scope: 'contact.form'))
          expect(page).to have_button(I18n.t(:send, scope: 'contact.form'))
        end

        it 'viewing the speakerinnen overview page' do
          click_link I18n.t(:speaker_index, scope: 'pages.home.speakers')
          # header
          expect(page).to have_css('#header__logo')
          expect(page).to have_link(I18n.t('layouts.application.signup'))
          # search
          expect(page).to have_css('input.profile__search')
          expect(page).to have_button(I18n.t(:search, scope: 'pages.home.search'))
          # profile
          expect(page).to have_content('2')
          expect(page).to have_link('Ada Lovelace')
          expect(page).to have_css('.profile-card', count: 2)
          expect(page).to have_css('.profile-subtitle', text: ada.main_topic)
          expect(page).to have_text(ada.iso_languages.first)
          # tag_cloud
          expect(page).to have_css('.topics-cloud')
          # link t profile
          expect(page).to have_link I18n.t(:to_profile, scope: 'profiles.show')
        end

        it 'viewing a single speakerin page' do
          click_link I18n.t(:speaker_index, scope: 'pages.home.speakers')
          click_link 'Ada Lovelace'
          # header
          expect(page).to have_css('#header__logo')
          expect(page).to have_link(I18n.t('layouts.application.signup'))
          # navi links
          expect(page).to have_link I18n.t(:home, scope: 'profiles.edit')
          # profile
          expect(page).to have_css('.profile-page')
          expect(page).to have_css('.profile-subtitle', text: ada.main_topic)
          expect(page).to have_text(ada.iso_languages.first)
          expect(page).to have_text('London')
          # contact
          expect(page).to have_button I18n.t(:contact, scope: 'profiles.show')
          expect(page).to_not have_link I18n.t(:edit, scope: 'profiles.show')
        end
      end

      describe 'registered user' do
        let!(:user) { FactoryBot.create(:profile, email: 'ltest@exp.com', password: 'rightpassword', password_confirmation: 'rightpassword') }

        context 'after login' do
          before { sign_in user }

          it 'should lead to the show view of the profile' do
            expect(page).to have_content(user.fullname)
            expect(page).to have_link I18n.t(:edit, scope: 'profiles.show')
          end

          it 'page has header and no admin link' do
            expect(page).to have_css('#header__logo')
            expect(page).to have_link(I18n.t(:my_profile, scope: 'layouts.application'))
            expect(page).to have_link(I18n.t('layouts.application.logout'))
            expect(page).to have_link('DE')
            expect(page).to_not have_link('Admin')
          end
        end

        context 'different login scenarios' do
          before { visit new_profile_session_path }

          it 'successful login' do
            fill_in 'profile_email', with: 'ltest@exp.com'
            fill_in 'profile_password', with: 'rightpassword'
            click_button I18n.t(:signin, scope: 'devise.registrations')

            expect(page).to have_css('.alert-info', text: I18n.t(:signed_in, scope: 'devise.sessions'))
            expect(page).to have_text I18n.t('devise.sessions.signed_in')
            expect(page).to have_link I18n.t('layouts.application.logout')
          end

          it 'wrong password' do
            fill_in 'profile_email', with: 'ltest@exp.com'
            fill_in 'profile_password', with: 'wrongpassword'
            click_button I18n.t(:signin, scope: 'devise.registrations')

            expect(page).to have_css('.alert', text: I18n.t(:invalid, scope: 'devise.failure'))
          end

          it 'empty password' do
            fill_in 'profile_email', with: 'ltest@exp.com'
            fill_in 'profile_password', with: ''
            click_button I18n.t(:signin, scope: 'devise.registrations')

            expect(page).to have_css('.alert', text: I18n.t(:invalid, scope: 'devise.failure'))
          end

          it 'non-existing email' do
            fill_in 'profile_email', with: 'false@exp.com'
            fill_in 'profile_password', with: 'rightpassword'
            click_button I18n.t(:signin, scope: 'devise.registrations')

            expect(page).to have_css('.alert', text: I18n.t(:invalid, scope: 'devise.failure'))
          end

          it 'empty email' do
            fill_in 'profile_email', with: ''
            fill_in 'profile_password', with: 'rightpassword'
            click_button I18n.t(:signin, scope: 'devise.registrations')

            expect(page).to have_css('.alert', text: I18n.t(:invalid, scope: 'devise.failure'))
          end
        end
      end
    end

  end # of language scope

end
