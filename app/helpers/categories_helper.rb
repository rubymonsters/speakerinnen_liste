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

  def category_profiles_ratio(category_id)
      category_profiles_count(category_id).to_f/Profile.count*100
  end
end
