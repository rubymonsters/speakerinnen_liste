require 'test_helper'

class ContactTest < ActionDispatch::IntegrationTest
  fixtures :profiles

  test "contact form is shown in german" do
    visit '/de'
    first(".btn-toolbar").click_link('Anzeigen')
    assert page.has_content?('Schreibe eine Mail an')
  end

  test "contact form is shown in english" do
    visit '/'
    first(".btn-toolbar").click_link('Show')
    assert page.has_content?('Write an email to')
  end
end
