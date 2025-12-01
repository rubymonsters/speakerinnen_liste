class Category < ApplicationRecord
  has_and_belongs_to_many :tags, class_name: 'ActsAsTaggableOn::Tag'

  validates :name, presence: true
  extend Mobility
  translates :name
  
  def self.sorted_categories
    Category.all.includes(:translations).order(:position)
  end

end
