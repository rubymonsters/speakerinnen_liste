RSpec.describe 'Navigation', type: :system do
  context 'logged in' do
    before do
      sign_in user
    end

    context 'as an unprivileged user' do
      let(:user) { FactoryBot.create(:profile) }

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
  end

  context 'guest user' do
    it 'page has header' do
      visit root_path

      expect(page).to have_css('#header__logo')
      expect(page).to have_link('Register as a speaker')
      expect(page).to have_link('Log in')
      expect(page).to have_link('DE')
    end

    it 'viewing the start page' do
      visit root_path

      expect(page).to have_css('#startpage__start-teaser')
      expect(page).to have_css('#startpage__teaser-bg-01')
      expect(page).to have_css('#startpage__teaser-bg-02')
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
  end

  describe 'logging in' do
    context 'registered user' do
      before do
        FactoryBot.create(:profile, email: 'ltest@exp.com', password: 'rightpassword', password_confirmation: 'rightpassword')
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
