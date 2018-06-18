# frozen_string_literal: true

require 'test_helper'

class StartPageTest < ActionDispatch::IntegrationTest
  fixtures :profiles
  fixtures :categories

  test 'start page is shown' do
    visit '/de'

    assert page.has_content?('Einloggen')
    assert page.has_content?('Als Speakerin registrieren')
    assert page.has_content?('Alle Speakerinnen* anschauen')
    assert page.has_content?('Twitter')
    assert page.has_content?('Impressum')
  end

  test 'start page is shown in english' do
    visit '/en'

    assert page.has_content?('Log in')
    assert page.has_content?('Register as a speaker')
    assert page.has_content?('Twitter')
    assert page.has_content?('Legal Details')
  end
end
