# require 'test_helper'

# class SearchForUserTest < ActionDispatch::IntegrationTest
#   def setup
#     @carla              = profiles(:one)
#     @carla.confirmed_at = Time.now
#     @carla.email        = 'carla@railsgirls.com'
#     @carla.firstname    = 'Carla'
#     @carla.lastname     = 'Drago'
#     @carla.bio          = 'weather, programming, sleeping, shopping, veggiemite and photos'
#     @carla.twitter      = 'tweeter'
#     @carla.published    = true
#     @carla.save!
#   end

#   test 'search for and find a user' do
#     visit('/en')
#     fill_in('search_quick', with: 'Carla')
#     click_button('Search')
#     click_link(@carla.fullname)

#     assert_equal current_path, profile_path(@carla, locale: 'en')
#   end
# end
