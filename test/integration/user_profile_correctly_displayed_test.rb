require 'test_helper'

class UserProfileCorrectlyDisplayedTest < ActionDispatch::IntegrationTest
  def setup
    @horst              = profiles(:one)
    @horst.confirmed_at = Time.now
    @horst.topic_list   = "fruehling"
    @horst.published    = true
    @horst.save

    @inge              = profiles(:two)
    @inge.confirmed_at = Time.now
    @inge.topic_list   = "fruehling", " ", "sommer"
    @inge.published    = true
    @inge.save
  end

  test "user profile is correctly displayed" do
    visit '/en'
    click_link('Horst lastname')

    assert page.has_css?('h1', count: 1), 'one headline of the fullname'
    assert page.has_content?('My topics')
    assert page.has_content?('Bio')
    assert page.has_content?('Twitter')
  end

  test "user profile is correctly displayed in german" do
    visit '/de'
    click_link('Inge lastname')

    assert page.has_css?('h1', count: 1), 'one headline of the fullname'
    assert page.has_content?('Meine Themen')
    assert page.has_content?('Bio')
    assert page.has_content?('Twitter')
  end
end
