# frozen_string_literal: true

class Api::V1::ProfilesController < ApplicationController
  before_action :api_authentication_required
  respond_to :json

  def index
    @profiles = Profile.is_published.where(id: params.fetch(:ids))
    # we use fetch because it raises an exception instead of returning nil
    render json: @profiles
  end

  def show
    @profile = Profile.is_published.find(params.fetch(:id))
    render json: @profile
  end

  private

  def api_authentication_required
    authenticate_or_request_with_http_basic do |name, token|
      api_token = ApiToken.find_by(name: name)
      api_token.token.present? && api_token.token == token
    end
  end
end
