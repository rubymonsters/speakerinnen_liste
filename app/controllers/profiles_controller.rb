class ProfilesController < ApplicationController
  include ProfilesHelper
  include CategoriesHelper
  include ActsAsTaggableOn::TagsHelper
  include SearchHelper

  before_action :set_profile, only: %i[show edit update destroy require_permission]
  before_action :require_permission, only: %i[edit destroy update]

  respond_to :json

  def index
    if params[:search]
      search_with_search_params
    elsif params[:category_id]
      search_with_category_id
    elsif params[:tag_filter]
      handle_tag_filter
    else
      get_all_profiles
    end
  end

  def show
    if @profile.published? || can_edit_profile?(current_profile, @profile)
      @message = Message.new
      @medialinks = @profile.medialinks.order(:position)
    else
      redirect_to profiles_url, notice: I18n.t('flash.profiles.show_no_permission')
    end
  end

  def edit
    @profile.build_missing_translations
  end

  def update
    if email_changed?
      @profile.update_column(:exported_at, nil)
    end

    if @profile.update(profile_params)
      redirect_to @profile, notice: I18n.t('flash.profiles.updated', profile_name: @profile.name_or_email)
    else
      @profile.build_missing_translations
      render action: 'edit'
    end
  end

  def destroy
    @profile.destroy
    redirect_to profiles_url, notice: I18n.t('flash.profiles.destroyed', profile_name: @profile.name_or_email)
  end

  def require_permission
    unless can_edit_profile?(current_profile, @profile)
      redirect_to profiles_url, notice: I18n.t('flash.profiles.no_permission')
    end
  end

  def render_footer?
    true
  end

  def typeahead
    suggestions = Profile.typeahead(params[:q], region: current_region)
    suggestions_array = suggestions.map { |suggestion| { 'text': suggestion.titleize } }
    suggestions_array.push('_source': {})
    respond_with(suggestions_array)
  end

  private

  def set_profile
    @profile = Profile.friendly.find(params[:id])
  end

  def email_changed?
    return false if profile_params[:email].blank?
    @profile.email != profile_params[:email]
  end

  def profile_params
    params.require(:profile).permit(
      :email, :password, :password_confirmation, :remember_me, :country, :state, { iso_languages: [] },
      :firstname, :lastname, :content, :name, :topic_list, :medialinks, :slug, :admin_comment,
      :main_topic, :bio, :twitter, :website, :website_2, :website_3, :profession, 
      :profession_en, :profession_de, :city, :city_en, :city_de, :website_en, :website_de, :website_2_en, :website_2_de, 
      :website_3_en, :website_3_de,
      :main_topic_en, :main_topic_de, :bio_en, :bio_de, :twitter_en, :twitter_de, :personal_note_en, :personal_note_de,
      :image, :copyright, :personal_note, :willing_to_travel, :nonprofit, :inactive,
      feature_ids: [], service_ids: [])
  end

  def search_with_search_params
    # these profiles we get back are just an array of hashes, not actual Profile objects!
    result = SearchProfilesByParams.call(params: params, region: current_region)
    if result.success?
      profiles = result.profiles
      @pagy, @records = pagy_array(profiles)
      set_aggregations(profiles)
    else
      handle_search_failure(result)
    end
  end

  def search_with_category_id
    result = SearchProfilesByCategory.call(category_id: params[:category_id], region: current_region)
    if result.success?
      profiles = result.profiles
      @category = result.category
      @pagy, @records = pagy(profiles)
      build_categories_and_tags_for_tags_filter
    else
      handle_search_failure(result)
    end
  end

  def search_with_tags
    result = SearchProfilesByTags.call(tags: params[:tag_filter], region: current_region)
    if result.success?
      profiles = result.profiles
      @category = result.category
      @tags = result.tags
      @pagy, @records = pagy(profiles)
      build_categories_and_tags_for_tags_filter
    else
      handle_search_failure(result)
    end
  end

  def get_all_profiles
    cache_key = [:get_all_profiles, current_region]
    result = Rails.cache.fetch(cache_key, expires_in: 2.hours) do
      GetAllProfiles.call(region: current_region)
    end
    if result.success?
      profiles = result.profiles
      @category = Category.first
      @pagy, @records = pagy(profiles)
      build_categories_and_tags_for_tags_filter
    else
      handle_search_failure(result)
    end
  end

  def handle_tag_filter
    if params[:tag_filter].empty?
      redirect_to profiles_url(anchor: "top"), notice: I18n.t('flash.profiles.no_tags_selected')
    else
      search_with_tags
    end
  end

  def set_aggregations(profiles)
    aggs = ProfileGrouper.new(params[:locale], profiles.map { |profile| profile[:id] }).agg_hash
    @aggs_languages = aggs[:languages]
    @aggs_cities = aggs[:cities]
    @aggs_states = aggs[:states]
    @aggs_countries = aggs[:countries]
  end

  def handle_search_failure(result)
    redirect_to profiles_url, alert: result.message
  end

  def build_categories_and_tags_for_tags_filter
    @categories = Rails.cache.fetch("sorted_categories", expires_in: 12.hours) do
      Category.sorted_categories
    end
    # builds variables like @tags_internet that contain the most used tags for each category
    @categories.each do |category|
      tags =
        ActsAsTaggableOn::Tag
          .belongs_to_category(category.id)
          .with_published_profile
          .with_regional_profile(search_region)
          .translated_in_current_language_and_not_translated(I18n.locale)
          .tap { |tags| tags.belongs_to_more_than_one_profile unless current_region }
          .most_used(100)
      instance_variable_set("@tags_#{category.short_name}", tags)
    end
  end
end
