class Admin::FeaturedProfilesController < Admin::BaseController
  def index
    @featured_profiles = FeaturedProfile.all
  end

  def new
    @featured_profile = FeaturedProfile.new()
  end

  def create
    @featured_profile = FeaturedProfile.new(featured_profile_params)
    if @featured_profile.save
      redirect_to admin_featured_profiles_path, notice: I18n.t('flash.featured_profiles.created', featured_profile_title: @featured_profile.title)
    else
      flash[:notice] = I18n.t('flash.featured_profiles.error')
      render action: 'new'
    end
  end

  def edit
  end

  private

  def featured_profile_params
    params.require(:featured_profile).permit(
      :title_de,
      :title_en,
      :description_de,
      :description_en,
      :public,
      :profile_ids,
      translations_attributes: %i[id title description locale]
    )
  end
end
