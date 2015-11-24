require 'test_helper'

class UserProfileCorrectlyDisplayedTest < ActionDispatch::IntegrationTest
  def setup
    @ada              = profiles(:one)
    @ada.confirmed_at = Time.now
    @ada.topic_list   = 'fruehling'
    @ada.bio          = 'Bio von Ada'
    @ada.published    = true
    @ada.save

    @inge              = profiles(:two)
    @inge.confirmed_at = Time.now
    @inge.topic_list   = 'fruehling', ' ', 'sommer'
    @inge.bio          = 'Bio von Inge'
    @inge.published    = true
    @inge.save
  end

  test 'user profile is correctly displayed' do
    visit '/en'
    click_link('Ada Lovelace')

    assert page.has_css?('h1'), 'one  of the fullname'
    assert page.has_content?('My topics')
    assert page.has_content?('My bio')
    assert page.has_content?('twitter')
  end

  test 'user profile is correctly displayed in german' do
    visit '/de'
    click_link('Inge lastname')

    assert page.has_css?('h1'), 'one headline of the fullname'
    assert page.has_content?('Meine Themen')
    assert page.has_content?('Meine Biografie')
    assert page.has_content?('Twitter')
  end
end
