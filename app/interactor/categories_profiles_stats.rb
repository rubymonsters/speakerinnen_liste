# frozen_string_literal: true

class CategoriesProfilesStats
  include Interactor

  def call
    region = normalize_region(context.region)

    context.profiles_count = Rails.cache.fetch(profiles_count_cache_key(region), expires_in: 12.hours) do
      profiles_count_query(region)
    end

    context.categories_profiles_counts = Rails.cache.fetch(categories_profiles_counts_cache_key(region), expires_in: 12.hours) do
      categories_profiles_counts_query(region)
    end
  end

  private

  def normalize_region(region)
    region == :ooe ? :'upper-austria' : region
  end

  # Query to count published profiles, considering locale and region
  def profiles_count_query(region)
    query = Profile.is_published
                   .joins(taggings: :tag)
                   .joins('LEFT OUTER JOIN tags_locale_languages tll ON tll.tag_id = tags.id')
                   .joins('LEFT OUTER JOIN locale_languages ll ON ll.id = tll.locale_language_id')
                   .where('ll.id IS NULL OR ll.iso_code = ?', I18n.locale.to_s)

    query = query.where(state: region) if region.present?
    query.distinct.count('profiles.id')
  end

  # Query to get counts of published profiles per category, considering locale (translated tags) and region
  # Returns a hash { category_id => profiles_count, ... }
  # tags without translation in current locale are also considered
  def categories_profiles_counts_query(region)
    Category
      .joins(categories_tags: { tag: :taggings })
      .joins("INNER JOIN profiles p ON p.id = taggings.taggable_id AND taggings.taggable_type = 'Profile'")
      .joins('LEFT OUTER JOIN tags_locale_languages tll ON tll.tag_id = tags.id')
      .joins('LEFT OUTER JOIN locale_languages ll ON ll.id = tll.locale_language_id')
      .where('ll.id IS NULL OR ll.iso_code = ?', I18n.locale.to_s)
      .where('p.published = TRUE')
      .then { |q| region.present? ? q.where('p.state = ?', region) : q }
      .group('categories.id')
      .distinct
      .count('p.id')
  end

  # creates cache key like "profiles_count:published:region:upper-austria.en"
  def profiles_count_cache_key(region)
    key = region.present? ? "profiles_count:published:region:#{region}" : 'profiles_count:published:all'
    "#{key}.#{I18n.locale}"
  end

  # creates cache key like "categories_profiles_counts:published:region:upper-austria.en"
  def categories_profiles_counts_cache_key(region)
    key = region.present? ? "categories_profiles_counts:published:region:#{region}" : 'categories_profiles_counts:published:all'
    "#{key}.#{I18n.locale}"
  end
end
