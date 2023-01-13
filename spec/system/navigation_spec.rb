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
          expect(page).to have_link('EN') if language == 'de'
          expect(page).to have_link('DE') if language == 'en'
          expect(page).to have_no_link('DE') if language == 'de'
          expect(page).to have_no_link('EN') if language == 'en'
          expect(page).to have_no_link('Admin')
        end

        it 'startpage has content' do
          expect(page).to have_css('.startpage__photo-bar')
          expect(page).to have_css('#startpage-categories__list')
          expect(page).to have_css('#startpage-newest_speaker')
          expect(page).to have_css('.profile-box', text: published_profile.main_topic)
          expect(page).to have_css('.profile-box', text: ada.main_topic)
          # we have each category bar twice, once for the name and one for the progress bar
          expect(page).to have_css('.category_item_science', count: 2)
          expect(page).to have_link(science.name)
        end

        it 'startpage has footer' do
          expect(page).to have_selector('footer')
          expect(page).to have_link('Twitter')
          expect(page).to have_link('Instagram')
          expect(page).to have_link('Facebook')
          expect(page).to have_link(I18n.t(:contact, scope: 'pages.footer'))
          expect(page).to have_link(I18n.t(:about, scope: 'pages.home'))
        end

        it 'viewing the contact page' do
          click_link I18n.t(:contact, scope: 'pages.footer')
          expect(page).to have_css('form label', text: I18n.t(:name, scope: 'contact.form'))
          expect(page).to have_css('form label', text: I18n.t(:email, scope: 'contact.form'))
          expect(page).to have_css('form label', text: I18n.t(:body, scope: 'contact.form'))
          expect(page).to have_css('form label', text: I18n.t(:subject, scope: 'contact.form'))
          expect(page).to have_button(I18n.t(:send, scope: 'contact.form'))
        end

        it 'viewing the speakerinnen overview page' do
          click_link I18n.t(:signup, scope: 'layouts.application')
          # header
          expect(page).to have_css('#header__logo')
          expect(page).to have_link(I18n.t('layouts.application.signup'))
          # register page
          expect(page).to have_button(I18n.t(:signup, scope: "devise.registrations"))
          expect(page).to have_field(I18n.t(:email, scope: "devise.registrations"))
          expect(page).to have_field(I18n.t(:password, scope: "devise.registrations"))
          expect(page).to have_field(I18n.t(:confirmation, scope: "devise.registrations"))
        end

        it 'viewing a single speakerin page' do
          click_link 'Ada Lovelace'
          # header
          expect(page).to have_css('#header__logo')
          expect(page).to have_link(I18n.t('layouts.application.signup'))
          # profile
          expect(page).to have_text(ada.firstname)
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
            # print page.html
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
