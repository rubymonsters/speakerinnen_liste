require 'test_helper'

class TagTest < ActiveSupport::TestCase
  fixtures :profiles

  test "tag get created and removed" do
    assert_equal profiles(:one).topics.length, 0
    profiles(:one).topic_list.add("Juni")
    profiles(:one).save!
    assert_equal profiles(:one).topic_list.length, 1, "First topic is there"
    profiles(:one).topic_list.remove("Juni")
    profiles(:one).save!
    assert_equal profiles(:one).topic_list.length, 0, "First is deleted"
  end

  test "tag get merged into another tag" do
    profiles(:one).topic_list.add("Somer", "Herbst")
    profiles(:two).topic_list.add("Sommer")



    tag = ActsAsTaggableOn::Tag.where(name: "Somer")
    tag.merge("Sommer")

  end

end
