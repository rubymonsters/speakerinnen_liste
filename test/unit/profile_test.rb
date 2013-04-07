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
    # p testprofile.errors

    assert !testprofile.valid?, "Does not validate Profile with already taken email"
  end
end
