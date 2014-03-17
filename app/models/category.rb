class Category < ActiveRecord::Base
  has_many :tags, through: :category_tags
  attr_accessible :name

end
