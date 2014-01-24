class Admin::ProfilesController < Admin::BaseController
  def index
    @profiles = Profile.order("created_at DESC")
  end

  def new
  end

  def create
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
    # AdminMailer.profile_published(@profile).deliver
    redirect_to admin_profiles_path, notice: (I18n.t("flash.profiles.updated"))
  end

  def unpublish
    @profile = Profile.find(params[:id])
    @profile.published = false
    @profile.save
    redirect_to admin_profiles_path, notice: (I18n.t("flash.profiles.updated"))
  end

end
