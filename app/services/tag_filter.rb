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
    else
      @tags
    end
  end
end
