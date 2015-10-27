require 'test_helper'

class TagIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @ada              = profiles(:one)
    @ada.confirmed_at = Time.now
    @ada.topic_list   = 'fruehling', 'kein herbst'
    @ada.published    = true
    @ada.save

    @inge              = profiles(:two)
    @inge.confirmed_at = Time.now
    @inge.topic_list   = 'fruehling', ' ', 'sommer'
    @inge.published    = true
    @inge.save

    @anon              = profiles(:three)
    @anon.confirmed_at = Time.now
    @anon.topic_list   = 'winter', 'fruehling'
    @anon.save
  end

  test 'show tagging' do
    visit 'de/profiles'
    click_link('Einloggen')
    fill_in('profile[email]', with: 'ada@mail.de')
    fill_in('profile[password]', with: 'Testpassword')
    click_button 'Anmelden'

    visit profile_path(@ada, locale: 'de')
    click_link('Profil bearbeiten')

    topic_list = find_field('profile[topic_list]').value
    assert_includes topic_list, 'kein herbst'
    assert_includes topic_list, 'fruehling'
  end

  test 'show Fruehling tag' do
    visit '/profiles'
    assert page.has_content?('fruehling')
    within '.topics-cloud' do
      click_link('fruehling')
    end
  end

  test 'tag with blank works' do
    visit '/profiles'
    assert page.has_content?('kein herbst')
    within '.topics-cloud' do
      click_link('kein herbst')
    end
  end

  test 'tags with slash use %2F for the link generating in profiles show' do
    @ada.topic_list << 'kein/winter'
    @ada.save
    visit '/profiles'
    assert page.has_content?('kein/winter')
    within '.topics-cloud' do
      click_link('kein/winter')
    end

    visit '/profiles/1'
    assert page.has_content?('kein/winter')
    click_link('kein/winter')
  end
end
