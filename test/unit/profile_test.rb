require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  fixtures :profiles

  test "firstname is there" do
    assert_equal profiles(:one).firstname, "Horst", "Firstname is there"
  end

  test "admin? is true when an admin user" do
    profile = Profile.new
    profile.admin = true
    profile.save
    assert profile.admin?, "returns true for an admin"
  end

  test "admin? is false for non-admin user" do
    profile = Profile.new
    profile.admin = false
    profile.save
    assert (not profile.admin?), "returns false for non-admin"
  end

  test "admin? is false by default" do
    assert (not Profile.new.admin?), "default setting for admin is false"
  end

  test "does not validate profile without email" do
    testprofile = Profile.new(
      :firstname => "Testfirstname",
      :lastname => "Testlastname",
      :bio => "Testbio"
    )
    testprofile.valid?
   # p testprofile.errors

    assert !testprofile.valid?, "Does not validate Profile without email"
  end

  test "does not validate profile with already taken email" do
    testprofile = Profile.new(:email => "horst@mail.de")
    testprofile.valid?
    assert !testprofile.valid?, "Does not validate Profile with already taken email"
  end

  test "fullname is firstname plus lastname" do
    assert_equal profiles(:one).fullname, profiles(:one).firstname + ' ' + profiles(:one).lastname, "Fullname is there"
    assert_equal profiles(:one).fullname, "Horst lastname", "Fullname is there"
  end

  test "that profile is properly built from twitter omniauth" do
    h = Hashie::Mash.new({:provider => "twitter", :uid => "uid", :info => {:nickname => "nickname", :name => "Maren"}})
    profile = Profile.from_omniauth(h)
    assert_equal profile.uid, "uid"
    assert_equal profile.twitter, "nickname"
  end

  test "twitter @ symbol correcty removed" do
    testprofile = Profile.new(:twitter => "@tweeter", :email => "me@me.com")
    expected_twitter = "tweeter"
    assert expected_twitter, testprofile.twitter
  end
end
