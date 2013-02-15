require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  fixtures :profiles

  test "firstname is there" do
    assert_equal profiles(:one).firstname, "Horst", "Firstname is there"
  end
end
