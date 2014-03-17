class CategoryTag < ActiveRecord::Base
  belongs_to :tag
  belongs_to :category

  # attr_accessible :title, :body
end
