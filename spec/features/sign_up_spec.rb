describe 'signup' do
  before do
    create(:ada, email: 'ada@mail.de' )
    page.driver.browser.set_cookie("cookie_consent=true")
  end

  context 'signup with email' do
    it 'sends out confirmation link' do
      visit root_path
      expect(page).to have_content('Register')
      click_link('Register as a speaker', match: :first)
      fill_in('profile[email]', with: 'barbara@mail.de')
      fill_in('profile[password]', with: 'Testpassword')
      fill_in('profile[password_confirmation]', with: 'Testpassword')
      click_button 'Sign up'

      expect(page).to have_content('A message with a confirmation link has been sent to your email address. Please open the link to activate your account.')
    end

    it "doesn't work when email is already been taken" do
      visit root_path
      expect(page).to have_content('Register')
      click_link('Register as a speaker', match: :first)
      fill_in('profile[email]', with: 'ada@mail.de')
      fill_in('profile[password]', with: 'Testpassword')
      fill_in('profile[password_confirmation]', with: 'Testpassword')
      click_button 'Sign up'

      expect(page).to have_content('has already been taken')
    end
  end
end
