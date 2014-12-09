class Admin::TagsController < Admin::BaseController
  before_filter :find_tag_and_category, :only => [:remove_category, :set_category]

  def index
    @tags       = ActsAsTaggableOn::Tag.all.sort_by {|tag| tag.name.downcase}
    @categories = Category.all
  end

  def edit
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
  end

  def update
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    if existing_tag = ActsAsTaggableOn::Tag.where(name: params[:tag][:name]).first
      existing_tag.merge(@tag)
      redirect_to categorization_admin_tags_path(page: params[:page]), notice: ("'#{@tag.name}' was merged with the tag '#{existing_tag.name}'.")
    elsif @tag.update_attributes(params[:tag])
      redirect_to categorization_admin_tags_path(page: params[:page]), notice: ("'#{@tag.name}' was updated.")
    else
      render action: 'edit'
    end
  end

  def destroy
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @tag.destroy
    redirect_to categorization_admin_tags_path, notice: ("'#{@tag.name}' was destroyed.")
  end

  def remove_category
    @tag.categories.delete @category
    redirect_to categorization_admin_tags_path(page: params[:page], q: params[:q], uncategorized: params[:uncategorized]), alert: ("The tag '#{@tag.name}' is deleted from the category '#{@category.name}'.")
  end

  def set_category
    @tag.categories << @category
    redirect_to categorization_admin_tags_path(page: params[:page], q: params[:q], uncategorized: params[:uncategorized]), notice: ("Just added the tag '#{@tag.name}' to the category '#{@category.name}'.")
  end

  def categorization
    relation = ActsAsTaggableOn::Tag.order('tags.name ASC').page(params[:page]).per(20)

    @tags_count = ActsAsTaggableOn::Tag.count
    if (params[:category_id]).present?
      @tags       = relation.includes(:categories).where('categories.id = ?', params[:category_id]).references(:categories)
    elsif (params[:q]).present? && (params[:uncategorized]).present?
      @tags       = relation.where('tags.name ILIKE ?', '%' + params[:q] + '%').includes(:categories).where('categories.id IS NULL')
    elsif (params[:q]).present?
      @tags       = relation.where('tags.name ILIKE ?', '%' + params[:q] + '%')
    elsif (params[:uncategorized]).present?
      @tags       = relation.includes(:categories).where('categories.id IS NULL').references(:categories)
    else
      @tags = relation
      @tags_count = nil
    end
    @categories = Category.all
  end

  private

  def find_tag_and_category
    @tag      = ActsAsTaggableOn::Tag.find(params[:id])
    @category = Category.find(params[:category_id])
  end

end
