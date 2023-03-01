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

    select_special_medicine_profiles

    @profiles_count = Profile.is_published.count
    @tags_count = ActsAsTaggableOn::Tag.count
    @categories = Category.sorted_categories
    @features   = Feature.published_feature.order(:position) if !current_region
  end

  def frauentag_2023
    select_special_medicine_profiles
  end

  def render_footer?
    true
  end

  private

  def select_special_medicine_profiles
    selected_profile_ids = [9380, 6507, 5290, 4421, 9495, 4943, 4533]
    @special_profiles = Profile
                        .with_attached_image
                        .includes(:translations)
                        .is_published
                        .where(id: selected_profile_ids)
                        .sort_by(&:updated_at)
  end
end
