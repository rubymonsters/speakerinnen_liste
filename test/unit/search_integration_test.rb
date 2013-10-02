require 'test_helper'

class SearchIntegrationTest < ActiveSupport::TestCase
  test "correctly integrated postgres fulltext search" do
    testprofile = Profile.create!(
      :email => "carla@railsgirls.com",
      :password => "PeterandPaul",
      :bio => "Carla is very interested in weather, programming, sleeping, shopping, veggiemite and photos."
    )
    results = Search.basic_search('WEATHER')
    assert_equal [testprofile], results.map(&:profile)
  end

  test "search should only search specified columns" do
    profile1 = Profile.create!(
      :email => "carla@example.org",
      :password => "password",
      :bio => "biography"
    )
    profile2 = Profile.create!(
      :email => "debbie@example.org",
      :password => "password",
      :twitter => "biography"
    )
    results = Search.basic_search("biography")
    assert_equal [profile1], results.map(&:profile)
  end

  test "search is across topics" do
    profile1 = Profile.create!(
      :email => "carla@example.org",
      :password => "password",
      :bio => "biography"
    )
    profile1.topic_list.add("summer")
    profile1.save!
    results = Search.basic_search("summer")
    assert_equal [profile1], results.map(&:profile)
  end
end