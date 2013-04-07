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

  test "restricted search should only search specified columns" do
    profile1 = Profile.create(
      :email => "carla@example.org",
      :password => "password",
      :bio => "biography")
    profile2 = Profile.create(
      :email => "debbie@example.org",
      :password => "password",
      :city => "biography")
    result = Profile.restricted_search("biography", [:bio])
    assert_equal [profile1], result 
  end

  test "create a hash that combines query and columns to search" do
    result = Profile.query_combiner("biography", [:bio, :email])
    expected = {:bio => "biography", :email => "biography"}
    assert_equal expected, result
  end

  test "there is a list of safe columns to search" do
    expected = [:bio, :firstname, :lastname, :languages, :city]
    assert_equal expected, Profile.safe_search_columns
  end

  test "search matches with at least one column" do
    profile1 = Profile.create(
      :firstname => 'Carla',
      :lastname => 'Drago',
      :email => "carla@example.org",
      :password => "password")
    result = Profile.safe_search("Drago")
    assert_equal [profile1], result 
  end
end  