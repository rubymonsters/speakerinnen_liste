# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    # we take the seven newest profiles and keep one as an empty example
    @newest_profiles = last_seven_profiles
    @profiles_count = Profile.is_published.count
    @tags_count = ActsAsTaggableOn::Tag.count
    @categories = Category.sorted_categories
    @features   = features_and_profiles unless current_region
  end

  def render_footer?
    true
  end

  private

  def features_and_profiles
    feature_records = Feature.published_feature.order(:position)

    feature_records.map do |feature|
      {
        title: feature.title,
        description: feature.description,
        profiles: feature.profiles
      }
    end
  end

  def last_seven_profiles
    Profile
      .with_attached_image
      .includes(:translations)
      .is_published
      .by_region(current_region)
      .main_topic_translated_in(I18n.locale)
      .last 7
  end
end
