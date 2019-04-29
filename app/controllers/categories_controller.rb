# frozen_string_literal: true

class CategoriesController < ApplicationController
  def index
    @categories = Category.sorted_categories
    @category = params[:category_id] ? Category.find(params[:category_id]) : Category.find(1)
    Category.all.includes(:translations).each do |category|
      instance_variable_set("@tags_#{category.short_name}",
        ActsAsTaggableOn::Tag.belongs_to_category(category.id)
                              .belongs_to_more_than_one_profile
                              .with_published_profile
                              .translated_in_current_language_and_not_translated(I18n.locale))
    end
    @tags_in_category_published = ActsAsTaggableOn::Tag
                                  .with_published_profile
                                  .belongs_to_category(params[:category_id])
                                  .translated_in_current_language_and_not_translated(I18n.locale)
    tag_names = @tags_in_category_published.pluck(:name)
    @profiles = profiles_for_tag(tag_names)
  end

  def profiles_for_tag(tag_names)
    Profile.is_published
           .random
           .includes(:taggings, :translations)
           .joins(:topics)
           .where(
             tags: {
               name: tag_names
             }
           )
           .page(params[:page])
           .per(24)
  end
end
