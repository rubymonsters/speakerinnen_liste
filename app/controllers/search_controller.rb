class SearchController < ApplicationController
  def search
    @results = Search.basic_search(params[:q]).page(params[:page]).per(10)
    @search_query = params[:q]
  end
end
