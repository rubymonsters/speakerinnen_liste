class ProfilesSearchController < ApplicationController
  include ProfilesHelper

  def show
    if params[:search]
      @profiles_all = ProfilesSearch.new(params[:search]).results.shuffle
      @profiles = Kaminari.paginate_array(@profiles_all).page(params[:page]).per(10)
    else
      redirect_to profiles_url
    end
    @tags = ActsAsTaggableOn::Tag.most_used(100)
  end

end
