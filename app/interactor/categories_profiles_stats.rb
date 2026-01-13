class CategoriesProfilesStats
  include Interactor

  def call
    region = context.region

    # count all published profiles (optionally filtered by region)
    context.profiles_count = if region.present?
                               Profile.is_published.where(state: region).count
                             else
                               Profile.is_published.count
                             end

    context.categories_profiles_counts = Rails.cache.fetch(cache_key(region), expires_in: 1.hour) do
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
end
