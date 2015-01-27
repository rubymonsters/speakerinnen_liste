require 'test_helper'

class CategoryIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @horst              = profiles(:one)
    @horst.confirmed_at = Time.now
    @horst.topic_list   = "fruehling"
    @horst.published    = true
    @horst.save

    @inge              = profiles(:two)
    @inge.confirmed_at = Time.now
    @inge.topic_list   = "fruehling", "sommer"
    @inge.published    = true
    @inge.save
  end

  test "test category with correct tags" do
    category_jahreszeiten = Category.new(name: "Jahreszeiten")
    category_jahreszeiten.save!

    tag_fruehling = ActsAsTaggableOn::Tag.find_by_name("fruehling")
    tag_sommer    = ActsAsTaggableOn::Tag.find_by_name("sommer")

    tag_fruehling.categories << category_jahreszeiten
    tag_sommer.categories << category_jahreszeiten

    assert_equal ActsAsTaggableOn::Tag.count, 2
    assert_equal tag_fruehling.categories.first.name, "Jahreszeiten"
    # because of the fixtures there are 3 categories
    assert_equal Category.all.count, 3
    visit '/'
    assert page.has_css?('ul.categories')
    assert page.has_content?('Jahreszeiten')
  end

end
