class SearchController < ApplicationController
 def search
   @results = Profile.safe_search(params[:q]).page(params[:page]).per(10)
 end
end
