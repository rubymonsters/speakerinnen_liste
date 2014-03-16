class ProfilesController < ApplicationController
  include ProfilesHelper

  before_filter :require_permision, :only=> [:edit, :destroy, :update]

  def index
    if params[:topic]
      @profiles = Profile.is_published.tagged_with(params[:topic]).order("created_at DESC").page(params[:page]).per(24)
    else
      @profiles = Profile.is_published.order("created_at DESC").page(params[:page]).per(24)
    end
  end

  def show
    @profile = Profile.find(params[:id])
    @message = Message.new
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
    build_missing_translations(@profile)
  end

  def update
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(params[:profile])
      redirect_to @profile, notice: (I18n.t("flash.profiles.updated"))
    else current_profile
      build_missing_translations(@profile)
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

  private

  def build_missing_translations(object)
    I18n.available_locales.each do |locale|
      unless object.translated_locales.include?(locale)
        object.translations.build(locale: locale)
      end
    end
  end

end
