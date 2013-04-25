require 'test_helper' 

class ProfileTest < ActionController::IntegrationTest
  def setup
    @horst = profiles(:one)
    @horst.confirmed_at = Time.now
    @horst.topic_list = "Fruehling"
    @horst.save

    @inge = profiles(:two)
    @inge.confirmed_at = Time.now
    @inge.topic_list = "Fruehling" " " "Sommer"
    @inge.save
  end

  test "show tagging" do
    visit '/profiles'
    click_link('Login')
    fill_in('profile[email]', :with => 'horst@mail.de')
    fill_in('profile[password]', :with => 'Testpassword')
    click_button "Login" 

    visit profile_path(@horst, :locale => "en")
    click_link('Edit')
    assert_equal find_field('profile[topic_list]').value, 'Fruehling'
    # save_and_open_page
  end

  test "show Sommer tag" do
    visit '/profiles'
    assert page.has_content?('Sommer')
    within "#topics_cloud" do
      click_link('Sommer')
    end
    assert page.has_css?('h3.profile_name', :count => 1)
    # save_and_open_page
  end

   test "show Fruehling tag" do
    visit '/profiles'
    assert page.has_content?('Fruehling')
    # save_and_open_page
    within "#topics_cloud" do
      click_link('Fruehling')
    end
    assert page.has_css?('h3.profile_name', :count => 2)
  end
 
end