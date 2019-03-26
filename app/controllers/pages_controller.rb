# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @profiles = Profile
                .includes(:translations)
                .is_published
                .main_topic_translated_in(I18n.locale)
                .random
                .limit(8)
    @categories = Category.sorted_categories
    @blog_posts = BlogPost.order('created_at DESC').limit(2)
    @features   = Feature.published_feature.order(:position)
  end

  def render_footer?
    true
  end
end
