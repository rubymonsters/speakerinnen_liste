require 'test_helper'

class AdminTest < ActionController::IntegrationTest

  test "visit admin page with right credentials" do
  	page.driver.browser.authorize('frodo', 'thering')
    visit '/admin'
    assert page.has_content?("Tags")
    assert page.has_content?("Profiles")
    assert_equal 200, page.status_code
  end

  test "visit admin page with wrong credentials" do
  	page.driver.browser.authorize('xyz', 'xyz')
    visit '/admin'
    assert_equal 401, page.status_code
  end
end
