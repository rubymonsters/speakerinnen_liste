# frozen_string_literal: true

module CategoriesHelper
  def category_link(category, anchor = nil)
    if anchor
      link_to category.name, category_path(category.id, anchor: anchor), class: ""
    else
      link_to category.name, category_path(category.id), class: ""
    end
  end

  def category_profiles_count(category_id)
    category_profiles = categories_profiles_counts.select { |e| e[0] == category_id }
    category_profiles.empty? ? 0 : category_profiles.first[1]
  end

  def category_profiles_ratio(category_id)
    category_profiles_count(category_id).to_f/profiles_count*100
  end

  private

  def profiles_count
    @profiles_count ||= Profile.count
  end

  def categories_profiles_counts
    Rails.cache.fetch("categories_profiles_counts.#{current_region || 'all'}", expires_in: 1.hours) do
      sql = <<~sql
        SELECT c.id, COUNT(DISTINCT p.id)
        FROM categories c
        JOIN categories_tags ct ON c.id = ct.category_id
        JOIN taggings t ON ct.tag_id = t.tag_id
        JOIN profiles p ON t.taggable_id = p.id
        WHERE p.published = true #{"AND state = ?" if current_region}
        GROUP BY (c.id)
      sql
      sql = ActiveRecord::Base.sanitize_sql([sql, current_region]) if current_region
      res = ActiveRecord::Base.connection.execute(sql)
      res.values
    end
  end
end
