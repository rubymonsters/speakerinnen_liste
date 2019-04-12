# frozen_string_literal: true

module CategoriesHelper
  def category_link(category, options = {})
    link_to category.name, categories_path(category_id: category.id), options
  end
end
