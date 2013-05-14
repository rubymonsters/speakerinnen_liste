require 'test_helper'

class AdminTest < ActionController::IntegrationTest

  def setup
    @jane = profiles(:jane)
    @jane.confirmed_at = Time.now
    @jane.save
  end

  test "visit admin page with right credentials" do
    visit '/admin'
    save_and_open_page
    assert page.has_content?("Tags")
    assert page.has_content?("Profiles")
    assert_equal 200, page.status_code
  end

end
