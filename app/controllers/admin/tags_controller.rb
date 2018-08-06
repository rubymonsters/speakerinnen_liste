# frozen_string_literal: true

class Admin::TagsController < Admin::BaseController
  before_action :find_tag_and_category, only: %i[remove_category set_category]
  before_action :set_tag, only: %i[edit update destroy find_tag_and_category]

  def new; end

  def show; end

  def edit; end

  def update
    if is_tag_language_update?
      set_tag_languages(@tag, params[:languages])
      redirect_to admin_tags_path(filter_params_from_session.merge(anchor: 'top-anchor')),
                  notice: "'#{@tag.name}' was updated."
    else
      if existing_tag = tag_name_exists?
        existing_tag.merge(@tag)
        redirect_to admin_tags_path(filter_params_from_session.merge(anchor: 'top-anchor')),
                    notice: "'#{@tag.name}' was merged with the tag '#{existing_tag.name}'."
      elsif @tag.update_attributes(tag_params)
        redirect_to admin_tags_path(filter_params_from_session.merge(anchor: 'top-anchor')),
                    notice: "'#{@tag.name}' was updated."
        else
        render action: 'edit'
      end
    end
  end

  def destroy
    @tag.destroy
    redirect_to admin_tags_path(filter_params_from_session.merge(anchor: 'top-anchor')),
                notice: "'#{@tag.name}' was destroyed."
  end

  def remove_category
    @tag.categories.delete @category
    redirect_to admin_tags_path(filter_params_from_session.merge(anchor: 'top-anchor')),
                alert: "The tag '#{@tag.name}' is deleted from the category '#{@category.name}'."
  end

  def set_category
    @tag.categories << @category
    redirect_to admin_tags_path(filter_params_from_session.merge(anchor: 'top-anchor')),
                notice: "Just added the tag '#{@tag.name}' to the category '#{@category.name}'."
  end

  def index
    @tags_count = ActsAsTaggableOn::Tag.count
    @tags = TagFilter.new(ActsAsTaggableOn::Tag.all.includes(:tags_locale_languages, :actsastaggableon_tags_categories), filter_params)
                     .filter
                     .order('tags.name ASC')
                     .page(params[:page])
                     .per(20)
    @categories = Category.all.includes(:translations)
    session[:filter_params] = filter_params
  end

  private

  def find_tag_and_category
    set_tag
    @category = Category.find(params[:category_id])
  end

  def set_tag
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
  end

  def set_tag_languages(tag, params_languages)
    tag.locale_languages.delete_all
    params_languages&.each do |iso_string|
      tag.locale_languages << LocaleLanguage.find_by(iso_code: iso_string)
    end
  end

  def is_tag_language_update?
    params[:languages].present? || params[:tag].blank?
  end

  def tag_name_exists?
    ActsAsTaggableOn::Tag.where(name: params[:tag][:name]).first if params[:tag].present? && params[:tag][:name].present?
  end

  def tag_params
    params.require(:tag).permit(
      :id,
      :tag,
      :name,
      :languages,
      locale_languages: %i[id iso_code _destroy]
    )
  end

  def filter_params
    @filter_params = {
      category_id: params[:category_id],
      q: params[:q],
      uncategorized: params[:uncategorized],
      filter_languages: params[:filter_languages],
      no_language: params[:no_language],
      page: params[:page]
    }
  end

  def filter_params_from_session
    session[:filter_params] || {}
  end
end
