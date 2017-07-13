class Admin::ProfilesController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  before_action :set_profile, only: [:show, :edit, :update, :destroy, :publish, :unpublish, :admin_comment]

  def index
    if params[:search]
      @profiles = Profile.is_confirmed.admin_search(params[:search]).order('created_at DESC').page(params[:page]).per(100)
    else
      @profiles = Profile.is_confirmed.order(sort_column + ' ' + sort_direction).order('created_at DESC').page(params[:page]).per(100)
    end
  end

  def new
  end

  def create
  end

  def show
    @medialinks = @profile.medialinks.order(:position)
  end

  def edit
    build_missing_translations(@profile)
  end

  def update
    if @profile.update_attributes(profile_params)
      redirect_to admin_profile_path(@profile), notice: (I18n.t('flash.profiles.updated', profile_name: @profile.name_or_email))
    else
      render :edit
    end
  end

  def destroy
    @profile.destroy

     respond_to do |format|
      format.html { redirect_to admin_profiles_path, notice: (I18n.t('flash.profiles.destroyed', profile_name: @profile.name_or_email)) }
      format.js   { render layout: false }
    end
  end

  def publish
    @profile.published = true
    @profile.save(validate: false)
    # Tells the AdminMailer to send publish mail to the speakerin
    AdminMailer.profile_published(@profile).deliver
    redirect_to admin_profiles_path, notice: (I18n.t('flash.profiles.updated', profile_name: @profile.name_or_email))
  end

  def unpublish
    @profile.published = false
    @profile.save(validate: false)
    redirect_to admin_profiles_path, notice: (I18n.t('flash.profiles.updated', profile_name: @profile.name_or_email))
  end

  def admin_comment
    if @profile.update_attributes(profile_params)
      redirect_to admin_profiles_path, notice: (I18n.t('flash.profiles.updated', profile_name: @profile.name_or_email))
    else
      render :index
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @profile = Profile.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
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
      :medialinks,
      :admin_comment,
      :bio_de,
      :bio_en,
      :main_topic_de,
      :main_topic_en,
      :twitter_de,
      :twitter_en,
      :website_de,
      :website_en,
      translations_attributes: [:id, :bio, :main_topic, :website, :locale])
  end

  def sort_column
    Profile.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'desc'
  end

end
