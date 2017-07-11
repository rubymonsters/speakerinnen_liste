class MedialinksController < ApplicationController
  before_filter :fetch_profile_from_params
  before_filter :ensure_own_medialinks

  before_action :set_medialink, only: [:edit, :update, :destroy]

  def index
  end

  def new
    @medialink = Medialink.new(url: 'http://')
  end

  def edit
  end

  def update
    if @medialink.update_attributes(medialink_params)
      redirect_to edit_profile_path(@profile), notice: (I18n.t('flash.medialink.updated'))
    else
      render action: 'edit'
    end
  end

  def destroy
    @medialink.destroy
    redirect_to edit_profile_path(@profile), notice: (I18n.t('flash.medialink.destroyed'))
  end

  def create
    @medialink = @profile.medialinks.build(medialink_params)
    if @medialink.save
      flash[:notice] = (I18n.t('flash.medialink.created').html_safe)
      redirect_to edit_profile_path(@profile)
    else
      flash[:notice] = (I18n.t('flash.medialink.error'))
      render action: 'new'
    end
  end

  def sort
    params[:medialink].each_with_index do |id, index|
      Medialink.where(id: id).update_all(position: index + 1)
    end
    render nothing: true
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
    params.require(:medialink).permit(:url, :title, :description, :position)
  end

  def profile_params
    params.require(:profile).permit(
      :email,
      :password,
      :password_confirmation,
      :remember_me,
      :city,
      :country,
      {iso_languages: []},
      :firstname,
      :lastname,
      :picture,
      :twitter,
      :remove_picture,
      :talks,
      :website,
      :content,
      :name,
      :topic_list,
      :media_url,
      :slug,
      :admin_comment,
      :main_topic_en,
      :main_topic_de,
      :bio_en,
      :bio_de,
      translations_attributes: [:id, :bio, :main_topic, :locale],
      medialinks_attributes: [:id, :url, :title, :description, :profile_id, :position])
  end

  def custom_params
    permitted = Profile.globalize_attribute_names
    params[:profile].permit(*permitted)
  end

end
