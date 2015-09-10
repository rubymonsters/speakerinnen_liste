class Category < ActiveRecord::Base
  has_and_belongs_to_many :tags, class_name: 'ActsAsTaggableOn::Tag'

  validates :name, presence: true
  translates :name, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations

  # to have the correct language variable for the yml file
  def language(translation)
    if translation.object.locale == :en && I18n.locale == :de
      'Englisch'
    elsif translation.object.locale == :en && I18n.locale == :en
      'English'
    elsif translation.object.locale == :de && I18n.locale == :en
      'German'
    else
      'Deutsch'
    end
  end
end
