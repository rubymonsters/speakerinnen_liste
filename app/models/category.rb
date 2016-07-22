class Category < ActiveRecord::Base
  has_and_belongs_to_many :tags, class_name: 'ActsAsTaggableOn::Tag'

  validates :name, presence: true
  translates :name, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations

  def self.sorted_categories
    categories_without_sonstige = where("name <> 'Sonstiges'").sort_by(&:name)
    category_sonstige           = where(name: 'Sonstiges')

    categories_without_sonstige + category_sonstige
  end
end
