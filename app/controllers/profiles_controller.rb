class ProfilesController < ApplicationController
  include ProfilesHelper
  include CategoriesHelper
  include ActsAsTaggableOn::TagsHelper

  before_action :set_profile, only: [:show, :edit, :update, :destroy, :require_permission]

  before_filter :require_permission, only: [:edit, :destroy, :update]

  def index
    if params[:topic]
      @profiles = profiles_for_scope(params[:topic])
    else
      @profiles = profiles_for_index
    end
    @tags = ActsAsTaggableOn::Tag.most_used(100)
  end

  def category
    @category = Category.find(params[:category_id])
    @tags     = @category.tags
    if @tags.any?
      @tag_names      = @tags.pluck(:name)
      @profiles       = profiles_for_scope(@tag_names)
      @published_tags = @profiles.map { |p| p.topics.pluck(:name) }.flatten.uniq
      @tags           = @tags.select { |t| @published_tags.include?(t.to_s) }
    else
      @profiles       = profiles_for_index
      redirect_to profiles_url, notice: ('No Tag for that Category found!')
    end
  end

  def show
    if @profile.published? || can_edit_profile?(current_profile, @profile)
      @message = Message.new
      @medialinks = @profile.medialinks.order(:position)
    else
      redirect_to profiles_url, notice: (I18n.t('flash.profiles.show_no_permission'))
    end
  end

  # action, view, routes should be deleted
  def new
    @profile = Profile.new
  end

  # should reuse the devise view
  def edit
    build_missing_translations(@profile)
  end

  def update
    if @profile.update_attributes(profile_params)
      redirect_to @profile, notice: (I18n.t('flash.profiles.updated', profile_name: @profile.name_or_email))
    elsif current_profile
      build_missing_translations(@profile)
      render action: 'edit'
    end
  end

  def destroy
    @profile.destroy
    redirect_to profiles_url, notice: (I18n.t('flash.profiles.destroyed', profile_name: @profile.name_or_email))
  end

  def require_permission
    return if can_edit_profile?(current_profile, @profile)

    redirect_to profiles_url, notice: (I18n.t('flash.profiles.no_permission'))
  end

  def render_footer?
    true
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @profile = Profile.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def profile_params
    params.require(:profile).permit(
      :email,
      :password,
      :password_confirmation,
      :remember_me,
      :city,
      :firstname,
      :languages,
      :lastname,
      :picture,
      :twitter,
      :remove_picture,
      :talks,
      :website,
      :content,
      :name,
      :topic_list,
      :media_url,
      :medialinks,
      :admin_comment,
      translations_attributes: [:id, :bio, :main_topic, :locale])
  end

  def build_missing_translations(object)
    I18n.available_locales.each do |locale|
      object.translations.build(locale: locale) unless object.translated_locales.include?(locale)
    end
  end

  def profiles_for_index
    Profile.is_published.order('created_at DESC').page(params[:page]).per(24)
  end

  def profiles_for_scope(tag_names)
    Profile.is_published
      .tagged_with(tag_names, any: true)
      .order('created_at DESC')
      .page(params[:page])
      .per(24)
  end
end
