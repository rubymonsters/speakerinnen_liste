class ProfilesSearchController < ApplicationController
  def show
    @profiles = ProfilesSearch.new(params[:search]).results.page(params[:page]).per(16)

    if @profiles.any?
      flash[:notice] = (I18n.t(:success, scope: 'search' ).html_safe) + (I18n.t(:result, scope: 'search', count: @profiles.total_count).html_safe)
    else
      flash[:notice] = (I18n.t(:empty, scope: 'search').html_safe)
    end

    @tags = ActsAsTaggableOn::Tag.most_used(100)
  end

end
