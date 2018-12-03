class Admin::FeaturedProfilesController < Admin::BaseController
  before_action :set_featured_profile, only: %i[edit update destroy announce_event stop_event]

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

  def update
    if @featured_profile.update_attributes(featured_profile_params)
      redirect_to admin_featured_profiles_path, notice: I18n.t('flash.featured_profiles.updated', featured_profile_title: @featured_profile.title)
    else
      render action: 'edit'
    end
  end

  def destroy
    @featured_profile.destroy
    redirect_to admin_featured_profiles_path, notice: I18n.t('flash.featured_profiles.destroyed', featured_profile_title: @featured_profile.title)
  end

  def announce_event
    @featured_profile.public = true
    @featured_profile.save
    redirect_to admin_featured_profiles_path, notice: I18n.t('flash.featured_profiles.updated', featured_profile_title: @featured_profile.title)
  end

  def stop_event
    @featured_profile.public = false
    @featured_profile.save
    redirect_to admin_featured_profiles_path, notice: I18n.t('flash.featured_profiles.updated', featured_profile_title: @featured_profile.title)
  end

  private

  PARAMS = [
    :title_de,
    :title_en,
    :description_de,
    :description_en,
    :public,
    :profile_ids,
    translations_attributes: %i[id title description locale]
  ]

  def featured_profile_params
    hash = params.require(:featured_profile).permit(*PARAMS)
    hash.merge(profile_ids: normalize_profile_ids(hash[:profile_ids]))
  end

  def normalize_profile_ids(ids)
    ids.split(",").map(&:to_i)
  end

  def set_featured_profile
    @featured_profile = FeaturedProfile.find(params[:id])
  end
end
