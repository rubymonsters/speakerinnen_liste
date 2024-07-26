# frozen_string_literal: true

class Category < ApplicationRecord
  has_and_belongs_to_many :tags, class_name: 'ActsAsTaggableOn::Tag'

  validates :name, presence: true
  translates :name, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations
  globalize_accessors locales: %i[en de], attributes: [:name]

  def self.sorted_categories
    Category.all.includes(:translations).order(:position)

  end

  def short_name
    self.name_en.split.first.downcase
  end

  def short_name
    self.name_en.split.first.downcase
  end
end
