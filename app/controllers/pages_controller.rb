# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    # we take the seven newest profiles and keep one as an empty example
    @newest_profiles = last_seven_profiles
    @tags_count = Rails.cache.fetch('tags_count', expires_in: 1.hour) do
      ActsAsTaggableOn::Tag.count
    end
    @categories = Category.sorted_categories
    @features   = features_and_profiles unless current_region

    stats = CategoriesProfilesStats.call(region: current_region)

    @profiles_count = stats.profiles_count
    @categories_profiles_counts = stats.categories_profiles_counts
  end

  def render_footer?
    true
  end

  private

  # Features preloaded to avoid N+1
  def features_and_profiles
    Feature.published_feature.includes(:profiles).order(:position).map do |feature|
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
