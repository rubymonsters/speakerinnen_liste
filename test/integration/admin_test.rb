require 'test_helper'

class AdminTest < ActionController::IntegrationTest

  def setup
    @jane = profiles(:jane)
    @jane.confirmed_at = Time.now
    @jane.save
  end

  test "visit admin page with right credentials" do
    visit '/'
    assert page.has_content?('Login')
    click_link('Login')
    assert page.has_content?('Email')
    fill_in('profile[email]', :with => 'jane_admin@server.org')
    fill_in('profile[password]', :with => 'Testpassword')
    click_button "Login" 
    
    click_link('admin')
    assert page.has_content?("Tags")
    assert page.has_content?("Profiles")
  end

end
