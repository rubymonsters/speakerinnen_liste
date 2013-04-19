require 'test_helper'

class StartPageTest < ActionDispatch::IntegrationTest
  fixtures :profiles

  test "start page is shown" do
    visit '/'

    assert page.has_css?('h3.profile_name', :minimum => 1)
    assert page.has_css?('h1', :count => 1), "just one headline"
    assert page.has_content?('Login')
    assert page.has_content?('Sign up')
    assert page.has_content?('Impressum')
  end

  test "start page is shown in german" do
    visit '/de'

    assert page.has_css?('h3.profile_name', :minimum => 1)
    assert page.has_css?('h1', :count => 1), "just one headline"
    assert page.has_content?('Anmelden')
    assert page.has_content?('Registrieren')
    assert page.has_content?('Impressum')
  end
end
