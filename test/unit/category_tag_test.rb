require 'test_helper'

class CategoryTagTest < ActiveSupport::TestCase
  test "create a CategoryTag" do
    category = Category.new(name: "Jahreszeiten")
    category.save
    assert_equal Category.all.count, 3
    profiles(:one).topic_list.add("Juni")
    profiles(:one).save!
    tag = ActsAsTaggableOn::Tag.find_by_name("juni")
    tag.save
    assert_equal tag.name, "juni"
    tag.categories << category
    assert_equal tag.categories.first.name, "Jahreszeiten"
    assert_equal category.tags.first.name, "juni"
  end

end
