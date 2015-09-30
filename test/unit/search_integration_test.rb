require 'test_helper'

class SearchIntegrationTest < ActiveSupport::TestCase
  def setup
    @carla = profiles(:one)
    @carla.confirmed_at = Time.now
    @carla.email = 'carla@railsgirls.com'
    @carla.password = 'PeterandPaul'
    @carla.translation.bio = 'Carla is very interested in weather, programming, sleeping, shopping, veggiemite and photos.'
    @carla.topic_list = 'fruehling', 'schnapsi'
    @carla.published = true
    @carla.save!

    @debbie = profiles(:two)
    @debbie.confirmed_at = Time.now
    @debbie.email = 'debbie@example.org'
    @debbie.password = 'PaulandPeter'
    @debbie.translation.bio = 'Debbie is interested in programming and teaching Ruby on Rails.'
    @debbie.topic_list = 'fruehling', ' ', 'sommer'
    @debbie.twitter = 'schnapsi'
    @debbie.published = true
    @debbie.save!
  end

  test 'correctly integrated postgres fulltext search' do
    results = Search.basic_search('WEATHER')
    assert_equal [@carla], results.map(&:profile)
  end

  test 'search should only search specified columns' do
    results = Search.basic_search('schnapsi')
    assert_equal [@carla], results.map(&:profile)
  end

  test 'search is across topics' do
    @carla.topic_list.add('summer')
    @carla.save!
    results = Search.basic_search('summer')
    assert_equal [@carla], results.map(&:profile)
  end
end
