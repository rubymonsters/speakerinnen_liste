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
      @pagy = result.pagy
      @records = result.records
      @category = result.category
      @tags_by_category = result.tags_by_category
      @aggregations = result.aggregations
    else
      redirect_to profiles_url, alert: result.message
    end
  end

  # show/edit/update/destroy etc remain the same
end
