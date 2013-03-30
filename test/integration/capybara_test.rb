require 'test_helper' 

class ProfileTest < ActionController::IntegrationTest
 
  test "viewing index page profile" do
    visit '/profiles'
    assert page.has_content?('Meine Themen')
  end

  test "login works not with wrong password" do
    Capybara.current_driver = Capybara.javascript_driver

    visit '/profiles'
    assert page.has_content?('Login')
    click_link('Login')
    assert page.has_content?('Email')
    fill_in('profile[email]', :with => 'Ranja@web.de')
    fill_in('profile[password]', :with => '12345678')
    click_button "Login" 
    # find(:xpath, "(//a[text()='Login'])[0]").click
    # page.first(:link, "Login").click
    save_and_open_page
    # within 'h1' do
    #     page.should have_content "Speakerinnen"
    #   end
    assert page.has_content?('Invalid email or password.')

    # assert page.has_selector? ".notice", text: "Signed in successfully."
    # assert page.has_content?('Signed in successfully.')
  end
 
end