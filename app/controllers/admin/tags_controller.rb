# frozen_string_literal: true

class Admin::TagsController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  before_action :set_tag, only: %i[edit update destroy find_tag_and_category]

  def new; end

  def show; end

  def edit
    @categories = Category.all.includes(:translations)
  end

  def update
    if existing_tag = tag_name_exists?
      existing_tag.merge(@tag)
      set_tag_languages(params[:tag][:languages])
      set_tag_categories(params[:tag][:categories])
      redirect_to admin_tags_path(filter_params_from_session.merge(anchor: "tag_#{@tag.id}")),
                  notice: "'#{@tag.name}' was merged with the tag '#{existing_tag.name}' ."
    elsif
      @tag.update(tag_params)
      set_tag_languages(params[:tag][:languages])
      set_tag_categories(params[:tag][:categories])
      redirect_to admin_tags_path(filter_params_from_session.merge(anchor: "tag_#{@tag.id}")),
                  notice: "'#{@tag.name}' was updated."
    else
      render action: 'edit'
    end
  end

  def destroy
    @tag.destroy
    redirect_to admin_tags_path(filter_params_from_session.merge(anchor: 'top-anchor')),
                notice: "'#{@tag.name}' was destroyed."
  end

  def index
    @categories = Category.all.includes(:translations)
    @tags_count = ActsAsTaggableOn::Tag.count
    @pagy, @records = pagy(
      TagFilter
        .new(ActsAsTaggableOn::Tag.all.includes(:tags_locale_languages, :actsastaggableon_tags_categories, :taggings), filter_params)
        .filter
        .order(sort_column + ' ' + sort_direction)
      )
    session[:filter_params] = filter_params
  end

  private

  def set_tag
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
  end

  def tag_name_exists?
    ActsAsTaggableOn::Tag.where(name: params[:tag][:name]).where.not(id: params[:id]).first if params[:tag].present? && params[:tag][:name].present? && params[:id].present?
  end

  def set_tag_languages(params_languages)
    @tag.locale_languages.delete_all
    params_languages&.each do |iso_string|
      @tag.locale_languages << LocaleLanguage.find_by(iso_code: iso_string)
    end
  end

  def set_tag_categories(params_categories)
    @tag.categories.delete_all
    params_categories&.each do |category_id|
      @tag.categories << Category.find(category_id)
    end
  end

  def tag_params
    params.require(:tag).permit(
      :id,
      :tag,
      :name,
      :languages,
      :categories,
      locale_languages: %i[id iso_code _destroy]
    )
  end

  def filter_params
    @filter_params = {
      category_id: params[:category_id],
      q: params[:q],
      filter_languages: params[:filter_languages],
      no_language: params[:no_language],
      page: params[:page]
    }
  end

  def filter_params_from_session
    session[:filter_params] || {}
  end

  def sort_column
    %w[tags.name taggings.created_at].include?(params[:sort]) ? params[:sort] : 'tags.name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
