# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    # we take the seven newest profiles and keep one as an empty example
    @newest_profiles = []
    last_seven_profiles.each do |profile|
      @newest_profiles << {
                      id: profile.id,
                      fullname: profile.fullname,
                      iso_languages: profile.iso_languages,
                      city: profile.city,
                      willing_to_travel: profile.willing_to_travel,
                      nonprofit: profile.nonprofit,
                      main_topic_or_first_topic: profile.main_topic_or_first_topic
                    }
    end

    select_special_medicine_profiles

    @profiles_count = Profile.is_published.count
    @tags_count = ActsAsTaggableOn::Tag.count
    @categories = Category.sorted_categories
    @features   = features_and_profiles unless current_region
  end

  def frauentag_2023
    select_special_medicine_profiles
  end

  def render_footer?
    true
  end

  private

  def features_and_profiles
    feature_records = Feature.published_feature.order(:position)

    results_array = []
    feature_records.each do |feature|
      results_array << {
                      title: feature.title,
                      description: feature.description,
                      profiles: profiles_array(feature.profiles)
                    }
    end
    results_array
  end

  def profiles_array(profiles)
    profiles_array = []
    profiles.each do |profile|
      profiles_array << {
        id: profile.id,
        fullname: profile.fullname,
        iso_languages: profile.iso_languages,
        city: profile.city,
        willing_to_travel: profile.willing_to_travel,
        nonprofit: profile.nonprofit,
        main_topic_or_first_topic: profile.main_topic_or_first_topic
      }
    end
    profiles_array
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

  def select_special_medicine_profiles
    selected_profile_ids = [9380, 6507, 5290, 4421, 9495, 4943, 4533]
    @special_profiles = Profile
                        .with_attached_image
                        .includes(:translations)
                        .is_published
                        .where(id: selected_profile_ids)
                        .order(updated_at: :desc)
  end
end
