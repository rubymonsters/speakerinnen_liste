# frozen_string_literal: true

require 'test_helper'

class SignUpTest < ActionDispatch::IntegrationTest
  test 'sign up with email sends out confirmation link' do
    page.driver.browser.set_cookie("cookie_consent=true")
    visit '/en'
    assert page.has_content?('Register')
    click_link('Register as a speaker')
    fill_in('profile[email]', with: 'bettina@mail.de')
    fill_in('profile[password]', with: 'Testpassword')
    fill_in('profile[password_confirmation]', with: 'Testpassword')
    click_button 'Sign up'

    assert page.has_content?('A message with a confirmation link has been sent to your email address. Please open the link to activate your account.')
  end

  test "sign up with email doesn't work when email is already been taken" do
    page.driver.browser.set_cookie("cookie_consent=true")
    visit '/en'
    assert page.has_content?('Register')
    click_link('Register as a speaker')
    fill_in('profile[email]', with: 'ada@mail.de')
    fill_in('profile[password]', with: 'Testpassword')
    fill_in('profile[password_confirmation]', with: 'Testpassword')
    click_button 'Sign up'

    assert page.has_content?('has already been taken')
  end

  test 'after signing up with twitter the user is required to enter the email address' do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
      provider: 'twitter',
      uid: '123545',
      info: {
        nickname: 'JonnieHallman'
      }
    )

    page.driver.browser.set_cookie("cookie_consent=true")
    visit '/en'
    click_link('Register as a speaker')
    # click_link('\Or sign up with Twitter')
    assert page.has_button?('Sign up')

    find_field('profile_email')
  end
end
