# frozen_string_literal: true

class MedialinksController < ApplicationController
  before_action :fetch_profile_from_params
  before_action :ensure_own_medialinks

  before_action :set_medialink, only: %i[edit update destroy]

  def index
    @medialinks = @profile.medialinks.order(:position)
  end

  def new
    @medialink = Medialink.new(url: 'https://')
  end

  def edit; end

  def update
    if @medialink.update(medialink_params)
      redirect_to profile_medialinks_path(@profile), notice: I18n.t('flash.medialink.updated')
    else
      render action: 'edit'
    end
  end

  def destroy
    @medialink.destroy
    redirect_to profile_medialinks_path(@profile), notice: I18n.t('flash.medialink.destroyed')
  end

  def create
    @medialink = @profile.medialinks.build(medialink_params)
    if @medialink.save
      flash[:notice] = I18n.t('flash.medialink.created')
      redirect_to profile_medialinks_path(@profile)
    else
      flash[:notice] = I18n.t('flash.medialink.error')
      render action: 'new'
    end
  end

  def sort
    params[:medialink].each_with_index do |id, index|
      Medialink.where(id: id).update_all(position: index + 1)
    end
    head :ok
  end

  protected

  def fetch_profile_from_params
    @profile = Profile.friendly.find(params[:profile_id])
  end

  def ensure_own_medialinks
    if @profile != current_profile
      redirect_to root_path, notice: 'Sorry, but you can not edit other peoples medialinks. OK?'
    else
      true
    end
  end

  private

  def set_medialink
    @medialink = @profile.medialinks.find(params[:id])
  end

  def medialink_params
    params.require(:medialink).permit(
      :url,
      :title,
      :description,
      :position,
      :language
    )
  end
end
