# frozen_string_literal: true

module CategoriesHelper
  def category_link(category, options = {})
    link_to category.name, category_path(category.id), options
  end
end
