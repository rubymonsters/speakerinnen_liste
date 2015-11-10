class ProfilesSearchController < ApplicationController

  def show
    @profiles = ProfilesSearch.new(params[:search]).results.page(params[:page]).per(16)
    @tags = ActsAsTaggableOn::Tag.most_used(100)
  end

end
