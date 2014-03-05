class ProfilesController < ApplicationController
  include ProfilesHelper

  before_filter :require_permision, :only=> [:edit, :destroy, :update]

  def index
    scope = Profile.is_published
    if params[:topic]
      @profiles = scope.tagged_with(params[:topic])
    else
      @profiles = scope.all
    end
  end

  def show
    @profile = Profile.find(params[:id])
    @message = Message.new
    @medialink = Medialink.new(url: "http://")
  end

  # action, view, routes should be deleted
  def new
    @profile = Profile.new
  end

# 	def create
# require 'pry' ; binding.pry
#     @profile = Profile.new(params[:profile])
#     if @profile.valid?
#       @profile.save!
#       sign_in @profile
#       redirect_to edit_profile_path(@profile)
#     else
#       flash.now.alert = @profile.errors.full_messages
#       render action: "new"
#     end
# 	end

  # should reuse the devise view
  def edit
    @profile = Profile.find(params[:id])
  end

  def update
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(params[:profile])
      redirect_to @profile, notice: (I18n.t("flash.profiles.updated"))
    else current_profile
      render action: "edit"
    end
  end

  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy
    redirect_to profiles_url, notice: (I18n.t("flash.profiles.destroyed"))
  end

  def require_permision
    profile = Profile.find(params[:id])
    unless can_edit_profile?(current_profile, profile)
      redirect_to profiles_url, notice: (I18n.t("flash.profiles.no_permission"))
    end
  end
end
