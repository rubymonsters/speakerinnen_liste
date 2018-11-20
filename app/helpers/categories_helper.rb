# frozen_string_literal: true

module CategoriesHelper
  def category_link(category, options = {})
    link_to category.name, root_path(category_id: category.id, anchor: "categories_anchor"), options
  end
end
