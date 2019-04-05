# frozen_string_literal: true

module CategoriesHelper
  def category_link(category, options = {})
    link_to category.name, category_path(category.id), options
  end

  def category_profiles_count(category_id)
    tags_in_category_published = ActsAsTaggableOn::Tag
                                  .belongs_to_category(category_id)
                                  .with_published_profile
    tag_names = tags_in_category_published.pluck(:name)
    profiles = Profile.is_published
           .includes(:translations)
           .joins(:topics)
           .where(
             tags: {
               name: tag_names
             }
           )
    profiles.count
  end

  def column_count(category_id)
      profiles_per_category = category_profiles_count(category_id)
      total_profiles = Profile.count/5 #delete devision by 5 
      ratio = (profiles_per_category.to_f/total_profiles)
      (ratio*740).ceil
  end
end
