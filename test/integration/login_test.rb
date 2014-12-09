require 'test_helper'

class LoginTest < ActionDispatch::IntegrationTest
  def setup
    horst              = profiles(:one)
    horst.confirmed_at = Time.now
    horst.save
  end

  test "login works with password" do
    visit '/'
    assert page.has_content?('Anmelden')
    click_link('Anmelden')
    #assert page.has_content?('profile_email')
    fill_in('profile[email]', with: 'horst@mail.de')
    fill_in('profile[password]', with: 'Testpassword')
    click_button "Anmelden"
    # opens the site where you are in the test right now
    # save_and_open_page

    assert page.has_content?('Erfolgreich angemeldet.')
  end

  test "login works not with wrong password" do
    # follows the test but doesnt work with confirmed profile
    # Capybara.current_driver = Capybara.javascript_driver

    visit '/'
    assert page.has_content?('Anmelden')
    click_link('Anmelden')
    #assert page.has_content?('profile_email')
    fill_in('profile[email]', with: 'horst@mail.de')
    fill_in('profile[password]', with: 'wrongpassword')
    click_button "Anmelden"
    # opens the site where you are in the test right now
    # save_and_open_page
    assert page.has_content?('Ungültige Anmeldedaten.')
  end
end
