# frozen_string_literal: true

class CategoriesController < ApplicationController
  def index
    @categories = Category.sorted_categories
    Category.all.each do |category|
      instance_variable_set("@tags_#{category.short_name}",
        ActsAsTaggableOn::Tag.belongs_to_category(category.id)
                              .belongs_to_more_than_one_profile
                              .with_published_profile
                              .with_language(I18n.locale))
    end
  end
end
