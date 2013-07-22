require 'test_helper'

class ContactTest < ActionDispatch::IntegrationTest
  fixtures :profiles

  test "contact form is shown in german" do
    visit '/de'
    click_link('Click here to contact us')
    assert page.has_content?('Your Message')
  end

  test "contact form is shown in english" do
    visit '/'
    click_link('Click here to contact us')
    assert page.has_content?('Your Message')
  end
end
