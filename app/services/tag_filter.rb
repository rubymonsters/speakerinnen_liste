class TagFilter
  def initialize(tags, params)
    @tags = tags
    @params = params
  end

  def filter
    if @params[:category_id].present?
      @tags
        .includes(:categories)
        .where('categories.id = ?', @params[:category_id])
        .references(:categories)
    elsif @params[:q].present? && @params[:uncategorized].present?
      @tags
        .where('tags.name ILIKE ?', '%' + @params[:q] + '%')
        .includes(:categories)
        .where('categories.id IS NULL')
        .references(:categories)
    elsif @params[:q].present?
      @tags
        .where('tags.name ILIKE ?', '%' + @params[:q] + '%')
    elsif @params[:uncategorized].present?
      @tags
        .includes(:categories)
        .where('categories.id IS NULL')
        .references(:categories)
    else
      @tags
    end
  end
end
