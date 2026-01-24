class ProfilesController < ApplicationController
  include ProfilesHelper
  include CategoriesHelper
  include ActsAsTaggableOn::TagsHelper
  include SearchHelper

  before_action :set_profile, only: %i[show edit update destroy require_permission]
  before_action :require_permission, only: %i[edit destroy update]

  respond_to :json

  def index
    result = Profiles::IndexInteractor.call(params: params, region: current_region)
    if result.success?
      if result.records.is_a?(Array)
        @pagy, @records = pagy_array(result.records)
      else
        @pagy, @records = pagy(result.records)
      end
      @category = result.category
      @categories = result.categories
      @tags_by_category = result.tags_by_category
      # Map aggregations for the view
      @aggs_languages  = result.aggregations[:languages]
      @aggs_cities     = result.aggregations[:cities]
      @aggs_states     = result.aggregations[:states]
      @aggs_countries  = result.aggregations[:countries]

      # Set @tags for the view when filtering by tag
      if params[:tag_filter].present?
        # Merge all selected categories' tags into @tags
        @tags = params[:tag_filter].split(',').map(&:strip)
      elsif @category && @tags_by_category.present?
        # Default to the category's tags
        @tags = @tags_by_category[@category.slug.to_sym]
      end
    else
      redirect_to profiles_url, alert: result.message
    end
  end

  def show
    if @profile.published? || can_edit_profile?(current_profile, @profile)
      @message = Message.new
      @medialinks = @profile.medialinks.order(:position)
    else
      redirect_to profiles_url, notice: I18n.t('flash.profiles.show_no_permission')
    end
  end

  def edit
  end

  def update
    @profile.update_column(:exported_at, nil) if email_changed?

    if @profile.update(profile_params)
      redirect_to @profile, notice: I18n.t('flash.profiles.updated', profile_name: @profile.name_or_email)
    else
      render action: 'edit'
    end
  end

  def destroy
    @profile.destroy
    redirect_to profiles_url, notice: I18n.t('flash.profiles.destroyed', profile_name: @profile.name_or_email)
  end

  def require_permission
    redirect_to profiles_url, notice: I18n.t('flash.profiles.no_permission') unless can_edit_profile?(current_profile, @profile)
  end

  def render_footer?
    true
  end

  def typeahead
    suggestions = Profile.typeahead(params[:q], region: current_region)
    suggestions_array = suggestions.map { |suggestion| { 'text': suggestion.titleize } }
    suggestions_array.push('_source': {})
    respond_with(suggestions_array)
  end

  private

  def set_profile
    @profile = Profile.friendly.find(params[:id])
  end

  def email_changed?
    return false if profile_params[:email].blank?

    @profile.email != profile_params[:email]
  end

  def profile_params
    params.require(:profile).permit(
      :email, :password, :password_confirmation, :remember_me, :country, :state, { iso_languages: [] },
      :firstname, :lastname, :content, :name, :topic_list, :medialinks, :slug, :admin_comment,
      :main_topic, :bio, :twitter, :website, :website_2, :website_3, :profession,
      :profession_en, :profession_de, :city, :city_en, :city_de, :website_en, :website_de, :website_2_en, :website_2_de,
      :website_3_en, :website_3_de,
      :main_topic_en, :main_topic_de, :bio_en, :bio_de, :twitter_en, :twitter_de, :personal_note_en, :personal_note_de,
      :instagram, :mastodon, :linkedin, :bluesky,
      :image, :copyright, :personal_note, :willing_to_travel, :nonprofit, :inactive,
      feature_ids: [], service_ids: []
    )
  end
end
