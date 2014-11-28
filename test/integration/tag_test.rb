require 'test_helper'

class TagTest < ActionController::IntegrationTest
  def setup
    @horst              = profiles(:one)
    @horst.confirmed_at = Time.now
    @horst.topic_list   = 'fruehling', 'kein herbst'
    @horst.published    = true
    @horst.save

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

  test "show tagging" do
    visit '/profiles'
    click_link('Anmelden')
    fill_in('profile[email]', with: 'horst@mail.de')
    fill_in('profile[password]', with: 'Testpassword')
    click_button "Anmelden"

    visit profile_path(@horst, locale: "de")
    click_link('Profil bearbeiten')
    assert_equal find_field('profile[topic_list]').value, 'kein herbst, fruehling'
  end

  test "show Fruehling tag" do
    visit '/profiles'
    assert page.has_content?('fruehling')
    within ".topics-cloud" do
      click_link('fruehling')
    end
    assert page.has_css?('div.name', count: 2)
    # save_and_open_page
  end

  test "tag with blank works" do
    visit '/profiles'
    assert page.has_content?('kein herbst')
    within ".topics-cloud" do
      click_link('kein herbst')
    end
    assert page.has_css?('div.name', count: 1)
  # save_and_open_page
  end
end
