require 'test_helper'

class CategoryIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @ada              = profiles(:one)
    @ada.confirmed_at = Time.now
    @ada.topic_list   = 'fruehling'
    @ada.published    = true
    @ada.save

    @inge              = profiles(:two)
    @inge.confirmed_at = Time.now
    @inge.topic_list   = 'fruehling', 'sommer'
    @inge.published    = true
    @inge.save
  end

  test 'test category with correct tags' do
    category_jahreszeiten = Category.new(name: 'Jahreszeiten')
    category_jahreszeiten.save!

    # fixtures names are not working due to globalize translates: https://github.com/globalize/globalize/issues/658
    # so I did a workaround
    cat1 = Category.find(1)
    cat1.name = "test"
    cat1.save!

    cat2 = Category.find(2)
    cat2.name = "test2"
    cat2.save!

    tag_fruehling = ActsAsTaggableOn::Tag.find_by_name('fruehling')
    tag_sommer    = ActsAsTaggableOn::Tag.find_by_name('sommer')

    tag_fruehling.categories << category_jahreszeiten
    tag_sommer.categories << category_jahreszeiten

    assert_equal ActsAsTaggableOn::Tag.count, 2
    assert_equal tag_fruehling.categories.first.name, 'Jahreszeiten'
    # because of the fixtures there are 3 categories
    assert_equal Category.all.count, 3
    visit '/de'
    assert page.has_content?('Jahreszeiten')

  end
end
