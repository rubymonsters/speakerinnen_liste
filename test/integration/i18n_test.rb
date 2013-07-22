require 'test_helper' 

class InternationalisationTest < ActionController::IntegrationTest

  test "locale de works" do
    visit '/'
    click_link('DE')
    save_and_open_page
    assert page.has_content?('Anmelden'), 'in Application.html.erb translation does not work'
    assert page.has_content?('Suche'), 'in yield Translation does not work'
  end

    test "locale en works" do
    visit '/'
    click_link('DE')
    click_link('EN')
    assert page.has_content?('My profile'), 'in Application.html.erb translation does not work'
    assert page.has_content?('Search'), 'in yield Translation does not work'
  end 
end