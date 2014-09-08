class ProfilesController < ApplicationController
  include ProfilesHelper
  include CategoriesHelper
  include ActsAsTaggableOn::TagsHelper


  before_filter :require_permission, only: [:edit, :destroy, :update]

  # new and destroy actions are performed by devise gem

  def index
    if params[:topic]
      @profiles = profiles_for_scope(params[:topic])
    else
      @profiles = profiles_for_index
    end
    @tags = ActsAsTaggableOn::Tag.most_used(100)
  end

=begin 
  profiles are displayed by a chosen category
  or
  all profiles are displayed if 
  no profiles with tags in this category exist 
  or if tags are not assigned to this category
=end
  def category
    @category = Category.find(params[:category_id])
    @tags     = @category.tags
    if @tags.any?
      @tag_names = @tags.pluck(:name)
      @profiles = profiles_for_scope(@tag_names)
      @published_tags = @profiles.map { |p| p.topics.pluck(:name) }.flatten.uniq
      @tags = @tags.select { |t| @published_tags.include?(t.to_s) }
    else
      @profiles = profiles_for_index
      redirect_to profiles_url, notice: (I18n.t("flash.profiles.category"))
    end
  end

  def show
    @profile = Profile.find(params[:id])

    if @profile.published? or can_edit_profile?(current_profile, @profile)

      @message = Message.new
      @medialinks = @profile.medialinks.order(:position)

    else
      redirect_to profiles_url, notice: (I18n.t("flash.profiles.show_no_permission"))
    end

  end

  # should reuse the devise view
  def edit
    @profile = Profile.find(params[:id])
    build_missing_translations(@profile)
  end

  def update
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(params[:profile])
      redirect_to @profile, notice: (I18n.t("flash.profiles.updated"))
    else
      build_missing_translations(@profile)
      render action: "edit"
    end
  end

  def require_permission
    profile = Profile.find(params[:id])
    unless can_edit_profile?(current_profile, profile)
      redirect_to profiles_url, notice: (I18n.t("flash.profiles.no_permission"))
    end
  end

  private

  def build_missing_translations(object)
    I18n.available_locales.each do |locale|
      unless object.translated_locales.include?(locale)
        object.translations.build(locale: locale)
      end
    end
  end

  def profiles_for_index
    Profile.is_published.order("created_at DESC").page(params[:page]).per(24)
  end

  def profiles_for_scope(tag_names)
    Profile.is_published
            .tagged_with(tag_names, any: true)
            .order("created_at DESC")
            .page(params[:page])
            .per(24)
  end

end
