class Admin::FeaturesController < Admin::BaseController
  before_action :set_feature, only: %i[edit update destroy announce_event stop_event]

  def index
    @featured_profiles = Feature.all
  end

  def new
    @featured_profile = Feature.new()
  end

  def create
    @featured_profile = Feature.new(feature_params)
    if @featured_profile.save
      redirect_to admin_features_path, notice: I18n.t('flash.features.created', featured_profile_title: @featured_profile.title)
    else
      flash[:notice] = I18n.t('flash.features.error')
      render action: 'new'
    end
  end

  def edit
    @featured_profile.profile_ids = @featured_profile.profile_ids.join(", ")
  end

  def update
    if @featured_profile.update_attributes(feature_params)
      redirect_to admin_features_path, notice: I18n.t('flash.features.updated', featured_profile_title: @featured_profile.title)
    else
      render action: 'edit'
    end
  end

  def destroy
    @featured_profile.destroy
    redirect_to admin_features_path, notice: I18n.t('flash.features.destroyed', featured_profile_title: @featured_profile.title)
  end

  def announce_event
    @featured_profile.public = true
    @featured_profile.save
    redirect_to admin_features_path, notice: I18n.t('flash.features.updated', featured_profile_title: @featured_profile.title)
  end

  def stop_event
    @featured_profile.public = false
    @featured_profile.save
    redirect_to admin_features_path, notice: I18n.t('flash.features.updated', featured_profile_title: @featured_profile.title)
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

  def feature_params
    hash = params.require(:feature).permit(*PARAMS)
    hash.merge(profile_ids: normalize_profile_ids(hash[:profile_ids]))
  end

  def normalize_profile_ids(ids)
    ids.split(",").map(&:to_i)
  end

  def set_feature
    @featured_profile = Feature.find(params[:id])
  end
end
