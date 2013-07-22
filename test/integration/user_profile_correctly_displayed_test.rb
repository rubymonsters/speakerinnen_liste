require 'test_helper'

class UserProfileCorrectlyDisplayedTest < ActionDispatch::IntegrationTest

  test "user profile is correctly displayed" do
    visit '/'
    page.first('div.speaker a').click

    assert page.has_css?('h2', :count => 1), 'one headline of the fullname'
    assert page.has_content?('My topics')
    assert page.has_content?('Bio')
    assert page.has_content?('Twitter')
  end

  test "user profile is correctly displayed in german" do
    visit '/de'
    page.first('div.speaker a').click

    assert page.has_css?('h2', :count => 1), 'one headline of the fullname'
    assert page.has_content?('Meine Themen')
    assert page.has_content?('Bio')
    assert page.has_content?('Twitter')
  end
end