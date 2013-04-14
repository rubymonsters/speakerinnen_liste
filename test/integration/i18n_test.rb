require 'test_helper' 

class InternationalisationTest < ActionController::IntegrationTest

  test "locale de works" do
    visit '/profiles'
    click_link('D')
    assert page.has_content?('Suchen'), 'in Application.html.erb translation does not work'
    assert page.has_content?('Themen'), 'in yield Translation does not work'
  end

    test "locale en works" do
    visit '/profiles'
    click_link('D')
    click_link('E')
    assert page.has_content?('Search'), 'in Application.html.erb translation does not work'
    assert page.has_content?('topics'), 'in yield Translation does not work'
  end 
end