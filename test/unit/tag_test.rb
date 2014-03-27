require 'test_helper'

class TagTest < ActiveSupport::TestCase
  fixtures :profiles

  test "tag get created and removed" do
    assert_equal profiles(:one).topics.length, 0
    profiles(:one).topic_list.add("juni")
    profiles(:one).save!
    assert_equal profiles(:one).topic_list.length, 1, "Topic is there"
    profiles(:one).topic_list.remove("juni")
    profiles(:one).save!
    assert_equal profiles(:one).topic_list.length, 0, "Topic is deleted"
  end

  test "tag forced lowercased" do
    assert_equal profiles(:one).topics.length, 0
    profiles(:one).topic_list.add("Juni")
    profiles(:one).save!
    assert_equal profiles(:one).topic_list.first,  "juni", "Tags ar e lowercase after saving them"
  end

  #test "tag get merged into another tag" do
    #profiles(:one).topic_list.add("Somer", "Herbst")
    #profiles(:two).topic_list.add("Sommer")



    #tag = ActsAsTaggableOn::Tag.where(name: "Somer")
    #tag.merge("Sommer")

  #end

end
