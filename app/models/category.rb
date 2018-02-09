class Category < ActiveRecord::Base
  has_and_belongs_to_many :tags, class_name: 'ActsAsTaggableOn::Tag'

  validates :name, presence: true
  translates :name, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations

  def self.sorted_categories
    categories_without_miscellaneous = Category.all.includes(:translations).where("id <> '12'").sort_by(&:name)
    category_miscellaneous = where(id: '12')

    categories_without_miscellaneous + category_miscellaneous
  end
end
