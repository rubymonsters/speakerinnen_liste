# frozen_string_literal: true

class CategoriesProfilesStats
  include Interactor

  def call
    region = context.region
    region = :'upper-austria' if region == :ooe

    # count all published profiles (optionally filtered by region)
    # filter by locale language via tags
    context.profiles_count = Rails.cache.fetch(profiles_count_cache_key(region), expires_in: 12.hours) do
      query = Profile.is_published
                     .joins("INNER JOIN taggings ON taggings.taggable_id = profiles.id AND taggings.taggable_type = 'Profile'")
                     .joins('INNER JOIN tags ON tags.id = taggings.tag_id')
                     .joins('INNER JOIN tags_locale_languages tll ON tll.tag_id = tags.id')
                     .joins('INNER JOIN locale_languages ll ON ll.id = tll.locale_language_id')
                     .where('ll.iso_code = ?', I18n.locale.to_s)

      query = query.where(state: region) if region.present?

      query.distinct.count
    end

    # creates a hash of category_id => published profiles count
    # e.g. { 1 => 254, 2 => 100, 3 => 324 }
    # for the given region (or all regions if none given)
    # filtered by locale language via tags
    # for all categories that have at least one published profile
    # is use in the category bars home view helper
    context.categories_profiles_counts = Rails.cache.fetch(cache_key(region), expires_in: 12.hours) do
      # Start with Category
      Category
        .joins(categories_tags: { tag: %i[taggings locale_languages] }) # join tags → taggings → locale_languages
        .joins("INNER JOIN profiles p ON p.id = taggings.taggable_id AND taggings.taggable_type = 'Profile'")
        .where(locale_languages: { iso_code: I18n.locale.to_s }) # filter by current locale
        .where('p.published = TRUE')                             # only published profiles
        .then { |q| region.present? ? q.where('p.state = ?', region) : q } # region filter
        .group('categories.id')
        .distinct
        .count('p.id')
    end
  end

  private

  def cache_key(region)
    "categories_profiles_counts.#{region || 'all'}"
  end

  def profiles_count_cache_key(region)
    if region.present?
      "profiles_count:published:region:#{region}"
    else
      'profiles_count:published:all'
    end
  end
end
