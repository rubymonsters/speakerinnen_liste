require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  test "create and delete Category" do
    category = Category.new(name: "Jahreszeiten")
    category.save
    assert_equal Category.all.count, 1, "create a category"
    category.destroy
    assert_equal Category.all.count, 0, "delete a category"
  end

end
