class ProfilesSearchController < ApplicationController
  def show
    @results = Profile.where('firstname ILIKE :query OR lastname ILIKE :query', query: "%#{params[:q]}%").page(params[:page]).per(16)
  end
end
