require 'test_helper'

class SearchIntegrationTest < ActiveSupport::TestCase
	test "correctly integrated postgres fulltext search" do 
    testprofile = Profile.create(
      :email => "carla@railsgirls.com", 
      :password => "PeterandPaul", 
      :bio => "Carla is very interested in weather, programming, sleeping, shopping, veggiemite and photos.")
    result = Profile.basic_search('WEATHER') 
    assert_equal [testprofile], result 
  end
end  