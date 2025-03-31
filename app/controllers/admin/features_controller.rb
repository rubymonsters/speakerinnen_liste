class Admin::FeaturesController < Admin::BaseController
  before_action :set_feature, only: %i[edit update destroy announce_event stop_event]

  def index
    @features = Feature.all
  end

  def new
    @feature = Feature.new()
  end

  def create
    @feature = Feature.new(feature_params)
    if @feature.save
      redirect_to admin_features_path, notice: I18n.t('flash.features.created', feature_title: @feature.title)
    else
      flash[:notice] = I18n.t('flash.features.error')
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @feature.update(feature_params)
      redirect_to admin_features_path, notice: I18n.t('flash.features.updated', feature_title: @feature.title)
    else
      render action: 'edit'
    end
  end

  def destroy
    feature_title = @feature.title
    @feature.destroy
    redirect_to admin_features_path, notice: I18n.t('flash.features.destroyed', feature_title: feature_title)
  end

  def announce_event
    @feature.public = true
    @feature.save
    redirect_to admin_features_path, notice: I18n.t('flash.features.announced', feature_title: @feature.title)
  end

  def stop_event
    @feature.public = false
    @feature.save
    redirect_to admin_features_path, notice: I18n.t('flash.features.stopped', feature_title: @feature.title)
  end

  private

  PARAMS = [
    :title_de,
    :title_en,
    :description_de,
    :description_en,
    :position,
    :public,
    profile_ids: [],
    translations_attributes: %i[id title description locale]
  ]

  def feature_params
    params.require(:feature).permit(*PARAMS)
  end

  def set_feature
    @feature = Feature.find(params[:id])
  end
end
