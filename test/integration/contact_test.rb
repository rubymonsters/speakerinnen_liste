require 'test_helper'

class ContactTest < ActionDispatch::IntegrationTest
  fixtures :profiles

  test "contact form is shown in german" do
    visit '/de'
    click_link('E-Mail')
    assert page.has_content?('Deine Nachricht')
  end

  test "contact form is shown in english" do
    visit '/en'
    click_link('Email')
    assert page.has_content?('Your Message')
  end
end