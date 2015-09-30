class SearchController < ApplicationController
  def search
    @results = Search.basic_search(params[:q]).page(params[:page]).per(16)
    @search_query = params[:q]

    if @results.size == 0
      redirect_to profiles_url, notice: (I18n.t(:empty, scope: 'search', searchparams: params[:q]).html_safe)
    end
  end
end
