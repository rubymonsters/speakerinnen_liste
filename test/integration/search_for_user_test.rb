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

    visit('/')
    fill_in('Search', :with => 'weather')
    click_button('Search')
    #do a search 
    #show a results page
    click_link(testprofile.fullname)
    #show profile page

    assert_equal current_path, profile_path(testprofile, {:locale=>"en"})

  end
end
