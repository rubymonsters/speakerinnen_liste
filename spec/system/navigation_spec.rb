# frozen_string_literal: true

RSpec.describe 'Navigation', type: :system do

  before do
    FactoryBot.create(:ada)
    FactoryBot.create(:published_profile, main_topic_en: 'climate', main_topic_de: 'Klima')
    FactoryBot.create(:cat_science)
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
          if language == "en"
            expect(page).to have_css('.profile-box', text: 'math')
            expect(page).to have_css('.profile-box', text: 'climate')
          else
            expect(page).to have_css('.profile-box', text: 'Mathematik')
          end
          expect(page).to have_css('.startpage-categories__list-links', count: 1)
          expect(page).to have_link('Science')
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
          if language == "en"
            expect(page).to have_css('.profile-subtitle', text: 'math')
            expect(page).to have_text('English')
          else
            expect(page).to have_css('.profile-subtitle', text: 'Mathematik')
            expect(page).to have_text('Englisch')
          end
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
          if language == "en"
            expect(page).to have_css('.profile-subtitle', text: 'math')
            expect(page).to have_text('London')
            expect(page).to have_text('English')
          else
            expect(page).to have_css('.profile-subtitle', text: 'Mathematik')
            expect(page).to have_text('London')
            expect(page).to have_text('Englisch')
          end
        end
      end

      describe 'registered user' do
        let!(:user) { FactoryBot.create(:profile, email: 'ltest@exp.com', password: 'rightpassword', password_confirmation: 'rightpassword') }
        before do
          page.driver.browser.set_cookie("cookie_consent=true")
        end

        it 'should lead to the show view of the profile' do
          sign_in user

          expect(page).to have_content(user.fullname)
          expect(page).to have_link(I18n.t('edit', scope: 'profiles.show'))
        end

        it 'page has header and no admin link' do
          sign_in user
          visit root_path

          expect(page).to have_css('#header__logo')
          expect(page).to have_link(I18n.t(:my_profile, scope: 'layouts.application'))
          expect(page).to have_link(I18n.t('layouts.application.logout'))
          expect(page).to have_link('DE')
          expect(page).to_not have_link('Admin')
        end

        context 'login' do
          before { visit new_profile_session_path }

          it 'successful login' do
            fill_in 'profile_email', with: 'ltest@exp.com'
            fill_in 'profile_password', with: 'rightpassword'
            click_button I18n.t(:signin, scope: 'devise.registrations')

            expect(page).to have_css('.notice', text: I18n.t(:signed_in, scope: 'devise.sessions'))
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

      context 'signed in as admin user' do
        let(:admin) { FactoryBot.create(:admin) }

        before do
          sign_in admin, language
        end

        it 'page has header and admin link' do
          expect(page).to have_text I18n.t('devise.sessions.signed_in')
          expect(page).to have_link I18n.t('layouts.application.logout')
          expect(page).to have_link('Admin')
          expect(page).to have_css('#header__logo')
          expect(page).to have_link(I18n.t(:my_profile, scope: 'layouts.application'))
          expect(page).to have_link('DE')
          expect(page).to have_link('EN')
        end

        describe 'access admin actions' do
          before { click_on 'Admin' }

          it 'show text' do
            expect(page).to have_content('Administration')
          end

          it 'should have localized links' do
            @lang_links_map[language].each_with_index do |link, _index|
              expect(page).to have_link(link)
            end
          end

        end
      end
    end

  end # of language scope

end
