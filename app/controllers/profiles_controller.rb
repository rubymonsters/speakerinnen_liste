# frozen_string_literal: true

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
      if params[:tag_filter].empty?
        redirect_to profiles_url(anchor: "top"), notice: I18n.t('flash.profiles.no_tags_selected')
        return
      end
      search_with_tags
    else
      search_without_params
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

  # should reuse the devise view
  def edit
    build_missing_translations(@profile)
  end

  def update
    if @profile.update(profile_params)
      redirect_to @profile, notice: I18n.t('flash.profiles.updated', profile_name: @profile.name_or_email)
    elsif current_profile
      build_missing_translations(@profile)
      render action: 'edit'
    end
  end

  def destroy
    @profile.destroy
    redirect_to profiles_url, notice: I18n.t('flash.profiles.destroyed', profile_name: @profile.name_or_email)
  end

  def require_permission
    return if can_edit_profile?(current_profile, @profile)

    redirect_to profiles_url, notice: I18n.t('flash.profiles.no_permission')
  end

  def render_footer?
    true
  end

  def typeahead
    suggestions = Profile.typeahead(params[:q], region: current_region)
    suggestions_array = suggestions.map do |suggestion|
      {'text': suggestion.titleize}
    end
    suggestions_array.push('_source': {})
    respond_with(suggestions_array)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @profile = Profile.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def profile_params
    params.require(:profile).permit(
      :email,
      :password,
      :password_confirmation,
      :remember_me,
      :country,
      :state,
      { iso_languages: [] },
      :firstname,
      :lastname,
      :content,
      :name,
      :topic_list,
      :medialinks,
      :slug,
      :admin_comment,
      :main_topic_en,
      :main_topic_de,
      :bio_en,
      :bio_de,
      :twitter_de,
      :twitter_en,
      :website_de,
      :website_en,
      :website_2_de,
      :website_2_en,
      :website_3_de,
      :website_3_en,
      :profession_en,
      :profession_de,
      :city_de,
      :city_en,
      :image,
      :copyright,
      :personal_note_de,
      :personal_note_en,
      :willing_to_travel,
      :nonprofit,
      :inactive,
      feature_ids: [],
      service_ids: [],
      translations_attributes: %i[id bio main_topic twitter website profession city locale]
    )
  end

  def search_with_search_params
    @profiles = matching_profiles.map(&:profile_card_details)
    @pagy, @records = pagy_array(@profiles)
    # search results aggregated according to certain attributes to display as filters
    aggs = ProfileGrouper.new(params[:locale], @profiles.map { |profile| profile[:id] }).agg_hash
    @aggs_languages = aggs[:languages]
    @aggs_cities = aggs[:cities]
    @aggs_states = aggs[:states]
    @aggs_countries = aggs[:countries]
  end

  def matching_profiles
    chain ||= Profile
      .includes(:translations)
      .with_attached_image
      .is_published
      .by_region(current_region)
      .search(params[:search])

    if params[:filter_city]
      chain = chain.by_city(params[:filter_city])
    end

    if params[:filter_country]
      chain = chain.by_country(params[:filter_country])
    end

    if params[:filter_language]
      chain = chain.by_language(params[:filter_language])
    end

    if params[:filter_state]
      chain = chain.by_state(params[:filter_state])
    end

    @matching_profiles = chain
  end

  def search_with_category_id
    @profiles = profiles_for_category
    @category = Category.find(params[:category_id])
    build_categories_and_tags_for_tags_filter
  end

  def profiles_for_category
    tag_names =
      ActsAsTaggableOn::Tag
      .with_published_profile
      .belongs_to_category(params[:category_id])
      .translated_in_current_language_and_not_translated(I18n.locale)
      .pluck(:name)

    @pagy, @records = pagy(
      Profile
        .with_attached_image
        .is_published
        .by_region(current_region)
        .includes(:topics)
        .where(tags: { name: tag_names })
      )
  end

  def search_with_tags
    @tags = params[:tag_filter].split(/\s*,\s*/)
    last_tag = @tags.last
    last_tag_id = ActsAsTaggableOn::Tag.where(name: last_tag).last.id
    @profiles = profiles_with_tags(@tags)
    @category =  Category.select{|cat| cat.tag_ids.include?(last_tag_id)}.last
    build_categories_and_tags_for_tags_filter
  end

  def profiles_with_tags(tags)
    @pagy, @records = pagy(
      Profile
        .is_published
        .by_region(current_region)
        .has_tags(tags)
      )
  end

  def search_without_params
    @profiles = profiles_for_index
    @category = Category.first
    build_categories_and_tags_for_tags_filter
  end

  def profiles_for_index
    @pagy, @records = pagy(
      Profile
        .with_attached_image
        .is_published
        .by_region(current_region)
        .includes(:translations)
        .main_topic_translated_in(I18n.locale)
        .order(created_at: :desc)
      )
  end

  def build_categories_and_tags_for_tags_filter
    @categories = Category.sorted_categories
    Category.all.includes(:translations).each do |category|
      tags = ActsAsTaggableOn::Tag
        .belongs_to_category(category.id)
        .with_published_profile
        .with_regional_profile(search_region)
        .translated_in_current_language_and_not_translated(I18n.locale)
      tags = tags.belongs_to_more_than_one_profile unless current_region
      tags = tags.most_used(100)
      instance_variable_set("@tags_#{category.short_name}", tags)
    end
  end
end
