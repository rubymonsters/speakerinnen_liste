# frozen_string_literal: true

module CategoriesHelper
  def category_link(category, options = {})
    link_to category.name, category_path(category.id), options
  end

  def category_profiles_count(category_id)
    tags_in_category_published = ActsAsTaggableOn::Tag
                                  .belongs_to_category(category_id)
                                  .with_published_profile
                                  .with_language(I18n.locale)
    tag_names = tags_in_category_published.pluck(:name)
    profiles = Profile.is_published
           .random
           .includes(:translations)
           .joins(:topics)
           .where(
             tags: {
               name: tag_names
             }
           )
    profiles_count = profiles.count
  end
end
