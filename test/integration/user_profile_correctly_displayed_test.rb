require 'test_helper'

class UserProfileCorrectlyDisplayedTest < ActionDispatch::IntegrationTest
  test "User Profile Correctly Displayed" do
    user = Profile.create(:firstname => "Debbie", :lastname => "Blass", :email => "sdf@asdf.com", :topics => "Ruby", :languages => "en", :bio => "bla bla")
    get profile_path(user)
    assert_response :success 
    # name is right & in right place
    assert_select 'h1', /#{user.firstname} #{user.lastname}/
    # email / twitter
    assert_select ".contact p", /#{user.email}/
    assert_select ".contact p", /#{user.twitter}/
    # topics
    assert_select ".topic p", user.topics
    # bio
    assert_select ".bio p", /#{user.bio}/
  end
end


#Twitter is optional. Test that word twitter does not appear on show page if someone did not enter anything there

#
