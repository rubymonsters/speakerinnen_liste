class Admin::MedialinksController < Admin::BaseController

  before_filter :fetch_profile_from_params

  before_action :set_medialink, only: [:edit, :update, :destroy]

  def index
    @medialinks = @profile.medialinks.order(:created_at)
  end

  def new
    @medialink = Medialink.new(url: 'http://')
  end

  def edit
  end

  def update
    if @medialink.update_attributes(medialink_params)
      # TODO translation flash
      redirect_to admin_profile_medialinks_path(@profile), notice: (I18n.t('flash.medialink.updated'))
    else
      render action: 'edit'
    end
  end

  def destroy
    @medialink.destroy
      # TODO translation flash
    redirect_to admin_profile_medialinks_path(@profile), notice: (I18n.t('flash.medialink.destroyed'))
  end

  def create
    @medialink = @profile.medialinks.build(medialink_params)
    if @medialink.save
      # TODO translation flash
      flash[:notice] = (I18n.t('flash.medialink.created'))
      redirect_to admin_profile_medialinks_path(@profile)
    else
      # TODO translation flash
      flash[:notice] = (I18n.t('flash.medialink.error'))
      render action: 'new'
    end
  end

  protected

  def fetch_profile_from_params
    @profile = Profile.find(params[:profile_id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medialink
      @medialink = @profile.medialinks.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def medialink_params
      params.require(:medialink).permit(:url, :title, :description, :position)
    end
end
