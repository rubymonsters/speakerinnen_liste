class Category < ApplicationRecord
  has_and_belongs_to_many :tags, class_name: 'ActsAsTaggableOn::Tag'

  validates :name, presence: true
  extend Mobility
  translates :name

  # Returns all categories sorted by position with translations preloaded
  def self.sorted_categories
    includes(:translations).order(:position)
  end
end
