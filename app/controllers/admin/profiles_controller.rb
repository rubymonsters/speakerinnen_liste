class Admin::ProfilesController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  def index
    @profiles = Profile.order(sort_column + " " + sort_direction).order("created_at DESC").page(params[:page]).per(100)
  end

  def show
    @profile = Profile.find(params[:id])
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def update
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(params[:profile])
      redirect_to admin_profile_path(@profile), notice: (I18n.t("flash.profiles.updated"))
    else
      render :edit
    end
  end

  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy
    redirect_to admin_profiles_path, notice: (I18n.t("flash.profiles.destroyed"))
  end

  def publish
    @profile = Profile.find(params[:id])
    @profile.published = true
    @profile.save
    # Tells the AdminMailer to send publish mail to the speakerin
    AdminMailer.profile_published(@profile).deliver
    redirect_to admin_profiles_path, notice: (I18n.t("flash.profiles.updated"))
  end

  def unpublish
    @profile = Profile.find(params[:id])
    @profile.published = false
    @profile.save
    redirect_to admin_profiles_path, notice: (I18n.t("flash.profiles.updated"))
  end

  def admin_comment
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(params[:profile])
      redirect_to admin_profiles_path, notice: (I18n.t("flash.profiles.updated"))
    else
      render :index
    end
  end

  private

  def sort_column
    Profile.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end
