class MedialinksController < ApplicationController
  def show
    @profile = Profile.find(params[:profile_id])
  end

  def create
    #make sure @profile is the profile to the correct user
    # current_profile
    @profile = Profile.find(params[:profile_id])
    @profile.medialinks.create(params[:medialink])
    redirect_to profile_path(@profile)
  end

end
