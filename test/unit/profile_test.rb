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
end
