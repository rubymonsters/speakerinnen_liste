# frozen_string_literal: true

module SignInHelper
  # TODO: Thats not correct any more
  # default locale of the site is 'de', so we set the same default here
  def sign_in(profile, language = 'de')
    visit new_profile_session_path
    page.driver.browser.set_cookie("cookie_consent=true")
    lang_map = { 'de' => 'DE', 'en' => 'EN' }
    click_on(lang_map[language], match: :first) if page.has_link?(lang_map[language])
    fill_in 'profile[email]', with: profile.email
    fill_in 'profile[password]', with: profile.password
    click_button I18n.t('devise.sessions.new.signin')
  end
end
