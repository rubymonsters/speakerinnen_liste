require 'test_helper'

class TagTest < ActionController::IntegrationTest
  def setup
    @horst = profiles(:one)
    @horst.confirmed_at = Time.now
    @horst.topic_list = "fruehling"
    @horst.published = true
    @horst.save

    @inge = profiles(:two)
    @inge.confirmed_at = Time.now
    @inge.topic_list = "fruehling", " ", "sommer"
    @inge.published = true
    @inge.save
  end

  test "show tagging" do
    visit '/profiles'
    click_link('Anmelden')
    fill_in('profile[email]', :with => 'horst@mail.de')
    fill_in('profile[password]', :with => 'Testpassword')
    click_button "Anmelden"

    visit profile_path(@horst, :locale => "de")
    click_link('Profil bearbeiten')
    assert_equal find_field('profile[topic_list]').value, 'fruehling'
  end

  test "show Sommer tag" do
    visit '/profiles'
    assert page.has_content?('sommer')
    within ".topics-cloud" do
      click_link('sommer')
    end
    assert page.has_css?('div.name', :count => 1)
  end

  test "show Fruehling tag" do
    visit '/profiles'
    assert page.has_content?('fruehling')
    within ".topics-cloud" do
      click_link('fruehling')
    end
    assert page.has_css?('div.name', :count => 2)
  end
end
