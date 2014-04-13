require 'test_helper'

class StartPageTest < ActionDispatch::IntegrationTest
  fixtures :profiles

  test "start page is shown" do
    visit '/'

    assert page.has_css?('div.photo-bar.speakerin-photo', minimum: 1)
    assert page.has_css?('div.badge', count: 1), "just one badge"
    assert page.has_content?('Anmelden')
    assert page.has_content?('Als Speakerin registrieren')
    assert page.has_css?('div.badge', count: 1), "just one badge"
    assert page.has_content?('Themenliste')
    assert page.has_content?('Alle Speakerinnen* anschauen')

    assert page.has_content?('Kontakt')
    assert page.has_content?('Impressum')
  end

  test "start page is shown in english" do
    visit '/en'

    assert page.has_css?('div.photo-bar.speakerin-photo', minimum: 1)
    assert page.has_css?('div.badge', count: 1), "just one badge"
    assert page.has_content?('Log in')
    assert page.has_content?('Register as a speaker')
    assert page.has_content?('Contact')
    assert page.has_content?('Legal Details')
  end
end
