# frozen_string_literal: true

module CategoriesHelper
  def category_link(category, anchor = nil)
    if anchor
      link_to category.name, category_path(category.id, anchor: anchor), class: ''
    else
      link_to category.name, category_path(category.id), class: ''
    end
  end

  def category_bar_widths(category_id)
    ratio = category_profiles_ratio(category_id)
    bar_1 = 40 + ratio
    bar_2 = 200 - bar_1
    [bar_1.round(2), bar_2.round(2)]
  end

  def category_profiles_count(category_id)
    @categories_profiles_counts[category_id] || 0
  end

  def category_profiles_ratio(category_id)
    return 0 if @profiles_count.zero?

    (category_profiles_count(category_id).to_f / @profiles_count) * 100
  end
end
