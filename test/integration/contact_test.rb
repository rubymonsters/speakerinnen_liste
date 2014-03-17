require 'test_helper'

class ContactTest < ActionDispatch::IntegrationTest
  fixtures :profiles

  test "contact form is shown in german" do
    visit '/de'
    click_link('Schreibe uns eine E-Mail')
    assert page.has_content?('Deine Nachricht')
  end

  test "contact form is shown in english" do
    visit '/en'
    click_link('Write us an email')
    assert page.has_content?('Your Message')
  end
end