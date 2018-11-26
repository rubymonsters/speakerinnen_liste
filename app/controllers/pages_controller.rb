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
    # if params[:category_id]
    #   @tags = ActsAsTaggableOn::Tag.belongs_to_category(params[:category_id])
    #                                .with_published_profile
    #                                .with_language(I18n.locale)
    # else
    #   @tags = ActsAsTaggableOn::Tag.with_published_profile
    #                                .with_language(I18n.locale)
    #                                .most_used(100)
    # end
    Category.all.each do |category|
      instance_variable_set("@tags_#{category.short_name}",
        ActsAsTaggableOn::Tag.belongs_to_category(category.id)
                              .belongs_to_more_than_one_profile
                              .with_published_profile
                              .with_language(I18n.locale))
    end
    @tags = ActsAsTaggableOn::Tag.with_published_profile
                                 .belongs_to_more_than_one_profile
                                 .with_language(I18n.locale)
                                 .most_used(100)
  end

  def render_footer?
    true
  end

end
