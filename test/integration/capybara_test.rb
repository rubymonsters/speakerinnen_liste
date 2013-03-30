require 'test_helper' 

class ProfileTest < ActionController::IntegrationTest
 
  test "viewing index page profile" do
    visit '/profiles'
    assert page.has_content?('Meine Themen')
  end

  test "login works" do
    visit '/profiles'
    assert page.has_content?('Login')
    click_link('Login')
    assert page.has_content?('Email')
    fill_in('profile[email]', :with => 'Ranja@web.de')
    fill_in('profile[password]', :with => '12345678')
    click_link('Login')
  end
 
end