require 'test_helper'

class StartPageTest < ActionDispatch::IntegrationTest
  fixtures :profiles
  fixtures :categories

  test 'start page is shown' do
    visit '/de'
    # comment out because css has changed
    # assert page.has_css?('div.photo-bar#speakerin-photo', minimum: 1)
    # assert page.has_css?('div.curie-badge', count: 1), "just one badge"
    assert page.has_content?('Einloggen')
    assert page.has_content?('Als Speakerin registrieren')
    # assert page.has_css?('ul li.category', minimum: 2)
    assert page.has_content?('Alle Speakerinnen* anschauen')
    assert page.has_content?('Kontakt')
    assert page.has_content?('Impressum')
  end

  test 'start page is shown in english' do
    visit '/en'
    # assert page.has_css?('div.photo-bar#speakerin-photo', minimum: 1)
    assert page.has_content?('Log in')
    assert page.has_content?('Register as a speaker')
    assert page.has_content?('Contact')
    assert page.has_content?('Legal Details')
  end
end
