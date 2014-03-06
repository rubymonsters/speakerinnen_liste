class MedialinksController < ApplicationController
  def index
    @profile    = current_profile
    @medialinks = @profile.medialinks.order(:created_at)
  end

  def new
    @profile = current_profile
    @medialink = Medialink.new(url: 'http://')
  end

  def edit
    @profile = current_profile
    @medialink = @profile.medialinks.find(params[:id])
  end

  def update
    @profile = current_profile
    @medialink = current_profile.medialinks.find(params[:id])
    if @medialink.update_attributes(params[:medialink])
      # TODO translation flash
      redirect_to profile_medialinks_path(current_profile.id), notice: (I18n.t("flash.medialink.updated"))
    else
      render action: "edit"
    end
  end

  def destroy
    @medialink = current_profile.medialinks.find(params[:id])
    @medialink.destroy
      # TODO translation flash
    redirect_to profile_medialinks_path(current_profile), notice: (I18n.t("flash.medialink.destroyed"))
  end

  def create
    @profile = current_profile
    @medialink = @profile.medialinks.build(params[:medialink])
    if @medialink.save
      # TODO translation flash
      flash[:notice] = (I18n.t("flash.medialink.created"))
      redirect_to profile_medialinks_path(@profile)
    else
      # TODO translation flash
      flash[:notice] = (I18n.t("flash.medialink.error"))
      render action: "new"
    end
  end

end
