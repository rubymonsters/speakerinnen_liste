class CategoriesProfilesStats
  include Interactor

  def call
    region = context.region
    region = 'upper-austria' if region == 'ooe'

    # count all published profiles (optionally filtered by region)
    context.profiles_count = Rails.cache.fetch(profiles_count_cache_key(region), expires_in: 12.hour) do
      if region.present?
        Profile.is_published.where(state: region).count
      else
        Profile.is_published.count
      end
    end

    # creates a hash of category_id => published profiles count
    # e.g. { 1 => 254, 2 => 100, 3 => 324 }
    # for the given region (or all regions if none given)
    # to create the category bars on the view of the homepage
    context.categories_profiles_counts = Rails.cache.fetch(cache_key(region), expires_in: 12.hour) do
      query = Category
              .joins(categories_tags: { tag: :taggings })
              .joins("INNER JOIN profiles p ON p.id = taggings.taggable_id AND taggings.taggable_type = 'Profile'")

      # apply region filter if present
      query = query.where('p.state = ?', region) if region.present?
      query = query.where('p.published = TRUE')

      query.group('categories.id')
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
