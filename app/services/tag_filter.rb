# frozen_string_literal: true

class TagFilter
  def initialize(tags, params)
    @tags = tags
    @params = params
  end

  def filter
    @tags = @tags
            .includes(:categories, :locale_languages)
            .references(:categories, :locale_languages)

    if @params[:category_id] == 'uncategorized'
        @tags = @tags.where('categories.id IS NULL')
    elsif @params[:category_id] == 'categorized'
      @tags = @tags.where('categories.id IS NOT NULL')
    elsif @params[:category_id].present?
      @tags = @tags.where('categories.id = ?', @params[:category_id])
    end

    @tags = @tags.where('tags.name ILIKE ?', '%' + @params[:q] + '%') if @params[:q].present?

    if @params[:filter_languages].present?
      tag_ids = ActsAsTaggableOn::Tag
                .joins(:locale_languages)
                .where('locale_languages.iso_code IN (?)', @params[:filter_languages])
                .group("tags_locale_languages.tag_id HAVING count(tags_locale_languages.tag_id) = #{@params[:filter_languages].length}")
                .pluck('tags_locale_languages.tag_id')
      @tags = @tags.where(id: tag_ids)
    end

    @tags = @tags.where('tags_locale_languages.id IS NULL') if @params[:no_language].present?
    @tags
  end
end
