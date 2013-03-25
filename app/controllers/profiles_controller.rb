class ProfilesController < ApplicationController
  include ProfilesHelper
  before_filter :require_permision, :only=> [:edit, :destroy, :update]

  def index
    @profiles = Profile.all
  end

  def show
    @profile = Profile.find(params[:id])   
  end

  # action, view, routes should be deleted
  def new
    @profile = Profile.new
  end

  # should reuse the devise view
  def edit
    @profile = Profile.find(params[:id])
  end

  def create
    @profile = Profile.new(params[:profile])
    if @profile.save
      redirect_to @profile, notice: 'Profile was successfully created.' 
    else
      render action: "new" 
    end
  end

  def update
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(params[:profile])
       redirect_to @profile, notice: 'Profile was successfully updated.' 
    else current_profile
      render action: "edit" 
    end
  end

  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy
    redirect_to profiles_url, notice: 'Profile was successfully deleted.'
  end

  def require_permision
    profile = Profile.find(params[:id])
    unless can_edit_profile?(current_profile, profile)
      redirect_to profiles_url, notice: 'No Permission to edit the Profile'
    end
  end
end
