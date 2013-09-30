class Admin::TagsController < Admin::BaseController
  def index
    @tags = ActsAsTaggableOn::Tag.all.sort_by {|tag| tag.name.downcase}
  end

  def edit
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
  end

  def update
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    if @tag.update_attributes(params[:tag])
      redirect_to admin_tags_path, notice: (I18n.t("flash.tags.updated"))
    else 
      render action: "edit" 
    end
  end

  def destroy
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @tag.destroy
    redirect_to admin_tags_path, notice: (I18n.t("flash.tags.destroyed"))
  end
end