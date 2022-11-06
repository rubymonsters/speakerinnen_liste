# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    # we take the seven newest profiles and keep one as an empty example
    @newest_profiles = Profile
                .includes(:translations)
                .is_published
                .by_region(current_region)
                .main_topic_translated_in(I18n.locale)
                .last 7
    @categories = Category.sorted_categories
    @features   = Feature.published_feature.order(:position) if !current_region
  end

  def render_footer?
    true
  end

end
