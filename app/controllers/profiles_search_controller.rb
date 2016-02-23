class ProfilesSearchController < ApplicationController

  def show
    if params[:search]
      @profiles = ProfilesSearch.new(params[:search]).results.order(:id).page(params[:page]).per(16)
    else
      redirect_to profiles_url
    end
    @tags = ActsAsTaggableOn::Tag.most_used(100)
  end

end
