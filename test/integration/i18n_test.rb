require 'test_helper'

class InternationalisationTest < ActionDispatch::IntegrationTest

  test "locale de works" do
    visit '/'
    assert page.has_content?('Einloggen'), 'in Application.html.erb translation does not work'
    assert page.has_content?('Suche'), 'in yield Translation does not work'
  end

  test "locale en works" do
    visit '/'
    click_link('EN', match: :first)
    assert page.has_content?('Log in'), 'in Application.html.erb translation does not work'
    assert page.has_content?('Search'), 'in yield Translation does not work'
  end
end
