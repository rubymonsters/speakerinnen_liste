require 'test_helper'

class LoginTest < ActionDispatch::IntegrationTest
  def setup
    ada              = profiles(:one)
    ada.confirmed_at = Time.now
    ada.save
  end

  test 'login works with password' do
    visit '/de'
    assert page.has_content?('Einloggen')
    click_link('Einloggen')

    fill_in('profile[email]', with: 'ada@mail.de')
    fill_in('profile[password]', with: 'Testpassword')
    click_button 'Anmelden'

    assert page.has_content?('Erfolgreich angemeldet.')
  end

  test 'login works not with wrong password' do
    visit '/de'
    assert page.has_content?('Einloggen')
    click_link('Einloggen')

    fill_in('profile[email]', with: 'ada@mail.de')
    fill_in('profile[password]', with: 'wrongpassword')
    click_button 'Anmelden'

    assert page.has_content?('Ungültige Anmeldedaten.')
  end
end
