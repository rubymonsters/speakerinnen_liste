class Admin::TagsController < Admin::BaseController
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
      redirect_to categorization_admin_tags_path, notice: ("'#{@tag.name}' was merged with the tag '#{existing_tag.name}'.")
    elsif @tag.update_attributes(params[:tag])
      redirect_to categorization_admin_tags_path, notice: ("'#{@tag.name}' was updated.")
    else
      render action: "edit"
    end
  end

  def destroy
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @tag.destroy
    redirect_to admin_tags_path, notice: (I18n.t("flash.tags.destroyed"))
  end

  def remove_category
    @tag      = ActsAsTaggableOn::Tag.find(params[:id])
    @category = Category.find(params[:category_id])
    @tag.categories.delete @category
    redirect_to categorization_admin_tags_path(page: params[:page], q: params[:q]), alert: ("The tag '#{@tag.name}' is deleted from the category '#{@category.name}'.")
  end

  def set_category
    @tag      = ActsAsTaggableOn::Tag.find(params[:id])
    @category = Category.find(params[:category_id])
    @tag.categories << @category
    redirect_to categorization_admin_tags_path(page: params[:page], q: params[:q]), notice: ("Just added the tag '#{@tag.name}' to the category '#{@category.name}'.")
  end

  def categorization
    if params[:q]
      @tags       = ActsAsTaggableOn::Tag.where("name ILIKE ?", "%" + params[:q] + "%")
                    .order('name ASC')
                    .page(params[:page])
                    .per(100)
    else
      @tags       = ActsAsTaggableOn::Tag.order('name ASC').page(params[:page]).per(100)
    end
    @categories = Category.all
  end
end
