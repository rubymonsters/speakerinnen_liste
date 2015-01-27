class Admin::ProfilesController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  before_action :set_profile, only: [:show, :edit, :update, :destroy, :publish, :unpublish, :admin_comment]

  def index
    @profiles = Profile.order(sort_column + ' ' + sort_direction).order('created_at DESC').page(params[:page]).per(100)
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
    if @profile.update_attributes(profile_params)
      redirect_to admin_profile_path(@profile), notice: (I18n.t('flash.profiles.updated'))
    else
      render :edit
    end
  end

  def destroy
    @profile.destroy
    redirect_to admin_profiles_path, notice: (I18n.t('flash.profiles.destroyed'))
  end

  def publish
    @profile.published = true
    @profile.save
    # Tells the AdminMailer to send publish mail to the speakerin
    AdminMailer.profile_published(@profile).deliver
    redirect_to admin_profiles_path, notice: (I18n.t('flash.profiles.updated'))
  end

  def unpublish
    @profile.published = false
    @profile.save
    redirect_to admin_profiles_path, notice: (I18n.t('flash.profiles.updated'))
  end

  def admin_comment
    if @profile.update_attributes(profile_params)
      redirect_to admin_profiles_path, notice: (I18n.t('flash.profiles.updated'))
    else
      render :index
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(
        :email,
        :password,
        :password_confirmation,
        :remember_me,
        :city,
        :firstname,
        :languages,
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
        translations_attributes: [:id, :bio, :main_topic, :locale])
    end

    def sort_column
      Profile.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
    end

end
