class ProfilesSearchController < ApplicationController
  def show
<<<<<<< HEAD
    @results = ProfilesSearch.new(params[:search]).results.page(params[:page]).per(16)
=======
    @results = Profile.where('firstname ILIKE :query OR lastname ILIKE :query', query: "%#{params[:q]}%").page(params[:page]).per(16)
>>>>>>> add tests and a first search
  end
end
