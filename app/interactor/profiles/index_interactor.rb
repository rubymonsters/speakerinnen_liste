# app/interactors/profiles/index_interactor.rb
class Profiles::IndexInteractor
  include Interactor
  include Pagy::Backend

  def call
    # Determine which search to perform
    if context.params[:search].present?
      search_profiles
    elsif context.params[:category_id].present?
      profiles_by_category
    elsif context.params[:tag_filter].present?
      profiles_by_tags
    else
      all_profiles
    end

    build_result if context.success?
  end

  private

  def search_profiles
    result = SearchProfilesByParams.call(params: context.params, region: context.region)
    handle_result(result)
  end

  def profiles_by_category
    result = SearchProfilesByCategory.call(category_id: context.params[:category_id], region: context.region)
    handle_result(result)
  end

  def profiles_by_tags
    if context.params[:tag_filter].empty?
      context.fail!(message: I18n.t('flash.profiles.no_tags_selected'))
    else
      result = SearchProfilesByTags.call(tags: context.params[:tag_filter], region: context.region)
      handle_result(result)
    end
  end

  def all_profiles
    cache_key = [:get_all_profiles, context.region]
    result = Rails.cache.fetch(cache_key, expires_in: 2.hours) do
      GetAllProfiles.call(region: context.region)
    end
    handle_result(result)
  end

  def handle_result(result)
    context.fail!(message: result.message) unless result.success?

    # store result for later use
    context.profiles_result = result
  end

  def build_result
    profiles = context.profiles_result.profiles

    # pass raw profiles to controller
    context.records = profiles

    # category
    context.category = context.profiles_result.respond_to?(:category) ? context.profiles_result.category : Category.first

    # categories
    context.categories = Rails.cache.fetch('sorted_categories', expires_in: 12.hours) { Category.sorted_categories }

    # aggregations
    context.aggregations = build_aggregations(profiles)

    # tags
    context.tags_by_category = build_tags_by_category
  end

  def build_aggregations(profiles)
    aggs = ProfileGrouper.new(context.params[:locale], profiles.map { |p| p[:id] }).agg_hash
    {
      languages: aggs[:languages],
      cities: aggs[:cities],
      states: aggs[:states],
      countries: aggs[:countries]
    }
  end

  def build_tags_by_category
    categories = Rails.cache.fetch('sorted_categories', expires_in: 12.hours) do
      Category.sorted_categories
    end

    categories.each_with_object({}) do |category, hash|
      tags =
        ActsAsTaggableOn::Tag
        .belongs_to_category(category.id)
        .with_published_profile
        .with_regional_profile(context.region)
        .translated_in_current_language_and_not_translated(I18n.locale)
        .tap { |t| t.belongs_to_more_than_one_profile unless context.region }
        .most_used(100)
      hash[category.slug.to_sym] = tags
    end
  end
end
