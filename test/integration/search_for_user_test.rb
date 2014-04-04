require 'test_helper'

class SearchForUserTest < ActionController::IntegrationTest
  test "search for and find a user" do
    testprofile = Profile.create(
        :email => "carla@railsgirls.com",
        :password => "PeterandPaul",
        :firstname => "Carla",
        :lastname => "Drago",
        :twitter => "tweeter",
        :bio => "weather, programming, sleeping, shopping, veggiemite and photos.")

    visit('/en')
    fill_in('search-field', :with => 'weather')
    click_button('Search')
    click_link(testprofile.fullname)

    assert_equal current_path, profile_path(testprofile, {:locale=>"en"})
  end
end
