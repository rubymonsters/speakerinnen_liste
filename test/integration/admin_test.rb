require 'test_helper'

class AdminTest < ActionDispatch::IntegrationTest

  def setup
    @jane              = profiles(:jane)
    @jane.confirmed_at = Time.now
    @jane.save
  end

  test "visit admin page with right credentials" do
    visit '/'
    assert page.has_content?('Einloggen')
    click_link('Einloggen')
    assert page.has_content?('Passwort vergessen?')
    fill_in('profile[email]', with: 'jane_admin@server.org')
    fill_in('profile[password]', with: 'Testpassword')
    click_button "Anmelden"
    first(:link, 'Admin').click
    assert page.has_content?("Tags")
    assert page.has_content?("Profile")
  end

  test "see on admin profile page the correct table" do
    visit '/'
    click_link('Einloggen')
    fill_in('profile[email]', with: 'jane_admin@server.org')
    fill_in('profile[password]', with: 'Testpassword')
    click_button "Anmelden"
    first(:link, 'Admin').click
    click_link('Profile')
    assert page.has_content?("Speakerinnen")
    assert page.has_content?("Jane")
    assert page.has_content?("Kommentar")
  end
end
