class TagFilter
  def initialize(tags, params)
    @tags = tags
    @params = params
  end

  def filter
    @tags = @tags
      .includes(:categories, :locale_languages)
      .references(:categories, :locale_languages)

    if @params[:category_id].present?
      @tags = @tags.where('categories.id = ?', @params[:category_id])
    end

    if @params[:q].present?
      @tags = @tags.where('tags.name ILIKE ?', '%' + @params[:q] + '%')
    end

    if @params[:uncategorized].present?
      @tags = @tags.where('categories.id IS NULL')
    end

    if @params[:filter_languages].present?
      tag_ids = ActsAsTaggableOn::Tag
             .joins(:locale_languages)
             .where('locale_languages.iso_code IN (?)', @params[:filter_languages])
             .group("locale_languages.id, tags.id HAVING count(locale_languages.id) = #{@params[:filter_languages].length}")
             .pluck('tags.id')
      @tags = @tags.where(id: tag_ids)
    end

    if @params[:no_language].present?
      @tags = @tags.where('tags_locale_languages.id IS NULL')
    end
    @tags
  end
end
