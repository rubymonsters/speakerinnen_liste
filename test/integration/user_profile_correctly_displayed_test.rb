# frozen_string_literal: true

require 'test_helper'

class UserProfileCorrectlyDisplayedTest < ActionDispatch::IntegrationTest
  def setup
    @ada              = Profile.where(firstname: 'Ada').first
    @ada.confirmed_at = Time.now
    @ada.topic_list   = 'fruehling'
    @ada.bio          = 'Bio von Ada'
    @ada.published    = true
    @ada.attributes   = { main_topic: 'Teatime', locale: :en }
    @ada.save!

    @inge              = Profile.where(firstname: 'Inge').first
    @inge.confirmed_at = Time.now
    @inge.topic_list   = 'fruehling', ' ', 'sommer'
    @inge.bio          = 'Bio von Inge'
    @inge.published    = true
    @inge.attributes   = { main_topic: 'Sauerkraut', locale: :de }
    @inge.save!
  end

  test 'user profile is correctly displayed' do
    visit '/en'
    click_link('Ada Lovelace', match: :first)

    assert page.has_css?('h1'), 'one  of the fullname'
    assert page.has_content?('My topics')
    assert page.has_content?('My bio')
  end

  test 'user profile is correctly displayed in german' do
    visit '/de'
    click_link('Inge lastname', match: :first)

    assert page.has_css?('h1'), 'one headline of the fullname'
    assert page.has_content?('Meine Themen')
    assert page.has_content?('Meine Biografie')
  end
end
