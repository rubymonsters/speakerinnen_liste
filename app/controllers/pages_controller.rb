# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    # we take the seven newest profiles and keep one as an empty example
    @newest_profiles = Profile
                .with_attached_image
                .includes(:translations)
                .is_published
                .by_region(current_region)
                .main_topic_translated_in(I18n.locale)
                .last 7
    @special_profiles = Profile
                .with_attached_image
                .includes(:translations)
                .is_published
                .where(id: [1, 2, 3]) #selected ids for medicin people

    @profiles_count = Profile.is_published.count
    @tags_count = ActsAsTaggableOn::Tag.count
    @categories = Category.sorted_categories
    @features   = Feature.published_feature.order(:position) if !current_region
  end

  def render_footer?
    true
  end

end
