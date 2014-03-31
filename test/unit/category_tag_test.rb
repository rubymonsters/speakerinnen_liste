require 'test_helper'

class CategoryTagTest < ActiveSupport::TestCase
  test "create a CategoryTag" do
    category = Category.new(name: "Jahreszeiten")
    category.save
    assert_equal category.id, 1
    profiles(:one).topic_list.add("Juni")
    profiles(:one).save!
    tag = ActsAsTaggableOn::Tag.find_by_name("juni")
    tag.save
    assert_equal tag.id, 1
    tag.categories << category
    assert_equal tag.categories.first.name, "Jahreszeiten"
    assert_equal category.tags.first.name, "juni"
  end

end
