require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  fixtures :profiles

  test "firstname is there" do
    assert_equal profiles(:one).firstname, "Horst", "Firstname is there"
  end

  test "is_admin?" do
    assert Profile.new(email: "jane_admin@server.org").is_admin?, "returns true for an admin"
    assert (not Profile.new(email: "some_other_email@server.org").is_admin?), "returns false for non-admin"
  end

  test "does not validate profile without email" do
    testprofile = Profile.new(
                          :firstname => "Testfirstname",
                          :lastname => "Testlastname",
                          :bio => "Testbio"
                          )
    testprofile.valid?
    p testprofile.errors

    assert !testprofile.valid?, "Does not validate Profile without email"
  end

  test "does not validate profile with already taken email" do
    testprofile = Profile.new(:email => "horst@mail.de")

    testprofile.valid?
    p testprofile.errors

    assert !testprofile.valid?, "Does not validate Profile with already taken email"
  end
end
