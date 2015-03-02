class ProfilesSearchController < ApplicationController
  def show
    @results = ProfilesSearch.new(params[:search]).results.page(params[:page]).per(16)
  end
end
