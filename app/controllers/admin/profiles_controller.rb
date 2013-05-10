class Admin::ProfilesController < ApplicationController
  def index
    @profiles = Profile.all.sort_by {|profile| profile.name.downcase}
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
