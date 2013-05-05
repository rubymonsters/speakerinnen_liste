class AdminController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.all
  end

  def edit
    @tags = ActsAsTaggableOn::Tag.find(params[:id])
  end

  def update
    @tags = ActsAsTaggableOn::Tag.find(params[:id])
    if @tags.update_attributes(params[:tags])
       redirect_to @tags, notice: (I18n.t("flash.tagss.updated"))
    else current_tags
      render action: "edit" 
    end
  end

  def destroy
    @tags = ActsAsTaggableOn::On.find(params[:id])
    @tags.destroy
    redirect_to tagss_url, notice: (I18n.t("flash.tagss.destroyed"))
  end

end
