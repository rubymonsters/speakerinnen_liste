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

  test "restricted searchable columns" do
    profile1 = Profile.create(
      :email => "carla@example.org",
      :password => "password",
      :bio => "biography")
    profile2 = Profile.create(
      :email => "debbie@example.org",
      :password => "password",
      :city => "biography")
    result = Profile.restricted_search ("biography")
    assert_equal [profile1], result 
  end
end  