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
    assert_equal profiles(:one).topic_list.first,  "juni", "Tags are lowercase after saving them"
  end

  test "tag get merged into another tag" do
    profiles(:one).topic_list.add("Somer", "Herbst")
    profiles(:one).save!
    profiles(:two).topic_list.add("Sommer")
    profiles(:two).save!
    assert_equal ActsAsTaggableOn::Tag.count,3
    old_tag = ActsAsTaggableOn::Tag.find_by_name("somer")
    new_tag = ActsAsTaggableOn::Tag.find_by_name("sommer")
    assert_equal old_tag.name, "somer"
    assert_equal new_tag.name, "sommer"
    assert_equal ActsAsTaggableOn::Tagging.count, 3

    #new_tag.merge(old_tag)
    #assert_equal profiles(:one).topic_list, ["sommer", "herbst"]
    #assert_equal profiles(:two).topic_list, ["sommer"]
  end

end
