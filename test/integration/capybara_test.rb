require 'test_helper' 

class ProfileTest < ActionController::IntegrationTest
  def setup
    horst = profiles(:one)
    horst.confirmed_at = Time.now
    horst.save
  end

  test "viewing index page profile" do
    visit '/profiles'
    assert page.has_content?('Meine Themen')
  end

  test "login works with password" do
    visit '/profiles'
    assert page.has_content?('Login')
    click_link('Login')
    assert page.has_content?('Email')
    fill_in('profile[email]', :with => 'horst@mail.de')
    fill_in('profile[password]', :with => 'Testpassword')
    click_button "Login" 
    # opens the site where you are in the test right now
    save_and_open_page

    assert page.has_content?('Signed in successfully.')
  end

  test "login works not with wrong password" do
    # follows the test but doesnt work with confirmed profile
    # Capybara.current_driver = Capybara.javascript_driver

    visit '/profiles'
    assert page.has_content?('Login')
    click_link('Login')
    assert page.has_content?('Email')
    fill_in('profile[email]', :with => 'horst@mail.de')
    fill_in('profile[password]', :with => 'wrongpassword')
    click_button "Login" 
    # opens the site where you are in the test right now
    save_and_open_page
    assert page.has_content?('Invalid email or password.')
  end
 
end