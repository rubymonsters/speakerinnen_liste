class SearchController < ApplicationController
 def search
   @results = Profile.safe_search (params[:q])
 end
end
