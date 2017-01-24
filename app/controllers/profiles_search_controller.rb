# class ProfilesSearchController < ApplicationController
#   include ProfilesHelper

#   def show
#     if params[:search]
#       @profiles = ProfilesSearch.new(params[:search])
#         .results
#         .page(params[:page])
#         .per(16)
#     else
#       redirect_to profiles_url
#     end
#     @tags = ActsAsTaggableOn::Tag.most_used(100)
#   end

# end
