require 'test_helper'

class StartPageTest < ActionDispatch::IntegrationTest
  fixtures :profiles

  test "start page is shown" do
    visit '/'

    assert page.has_css?('div.speaker .name', :minimum => 1)
    assert page.has_css?('div.badge', :count => 1), "just one badge"
    assert page.has_content?('Login')
    assert page.has_content?('Sign up')
    assert page.has_content?('Contact')
    assert page.has_content?('Impressum')
  end

  test "start page is shown in german" do
    visit '/de'

    assert page.has_css?('div.speaker .name', :minimum => 1)
    assert page.has_css?('div.badge', :count => 1), "just one badge"
    assert page.has_content?('Anmelden')
    assert page.has_content?('Als Speakerin registrieren')
    assert page.has_content?('Kontakt')
    assert page.has_content?('Impressum')
  end
end