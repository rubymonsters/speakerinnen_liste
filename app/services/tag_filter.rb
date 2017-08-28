class TagFilter
  def initialize(tags, params)
    @tags = tags
    @params = params
  end

  def filter
    @tags = @tags
      .includes(:categories, :tag_languages)
      .references(:categories, :tag_languages)

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
      #ToDo: refactor to speed up
      tag_ids = ActsAsTaggableOn::Tag
                   .joins(:tag_languages)
                   .where('tag_languages.language IN (?)', @params[:filter_languages])
                   .group("tag_languages.tag_id, tags.id HAVING count(tag_languages.tag_id) = #{@params[:filter_languages].length}")
                   .pluck('tags.id')

      @tags = @tags.where(id: tag_ids)
    end

    if @params[:no_language].present?
      @tags = @tags.where('tag_languages.id IS NULL')
    end
    @tags
  end
end
