require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  test 'create and delete Category' do
    category = Category.new(name: 'Jahreszeiten')
    category.save
    assert_equal Category.all.count, 3, 'create a category'
    category.destroy
    assert_equal Category.all.count, 2, 'delete a category'
  end

end
