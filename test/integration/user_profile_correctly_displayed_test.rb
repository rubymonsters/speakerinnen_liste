require 'test_helper'

class UserProfileCorrectlyDisplayedTest < ActionDispatch::IntegrationTest
  fixtures :profiles
  test "User Profile Correctly Displayed" do

    # user = Profile.create(:firstname => "Debbie", :lastname => "Blass", :email => "sdf@asdf.com", :topics => "Ruby", :languages => "en", :bio => "bla bla")
    # use fixtures -> profiles.yml
    get profile_path(profiles(:one))
    assert_response :success 
    # name is right & in right place
    assert_select 'h2', /#{profiles(:one).firstname} #{profiles(:one).lastname}/
    # email / twitter
    assert_select "div", /#{profiles(:one).email}/
    assert_select "div", /#{profiles(:one).twitter}/
    # topics
    assert_select "div", /#{profiles(:one).topics}/
    # bio
    assert_select "div", /#{profiles(:one).bio}/
  end
end


#Twitter is optional. Test that word twitter does not appear on show page if someone did not enter anything there

#
