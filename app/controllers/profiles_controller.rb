class ProfilesController < ApplicationController
  
  def index
    @profiles = Profile.all
  end


  def show
    @profile = Profile.find(params[:id])   
  end


  def new
    @profile = Profile.new
  end

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
    else
      render action: "edit" 
    end
  end

  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy
    redirect_to profiles_url 
  end
end
