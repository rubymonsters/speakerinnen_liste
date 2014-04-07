module CategoriesHelper

  def category_link(category, options={})
    link_to category.name, category_path(category.name), options
  end

end

