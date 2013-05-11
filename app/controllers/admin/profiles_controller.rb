class Admin::ProfilesController < ApplicationController
  def index
    @profiles = Profile.all.sort_by {|profile| profile.firstname.downcase}
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def update
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(params[:profile])
      redirect_to admin_profile_path(@profile), notice: (I18n.t("flash.profiles.updated"))
    else 
      render :edit 
    end
  end

  def destroy
  end
end
