# frozen_string_literal: true

class ProfilesController < ApplicationController
  include ProfilesHelper
  include CategoriesHelper
  include ActsAsTaggableOn::TagsHelper
  include SearchHelper

  before_action :set_profile, only: %i[show edit update destroy require_permission]

  before_action :require_permission, only: %i[edit destroy update]

  respond_to :json

  def index
    if params[:topic]
      @tags = params[:topic].split(/\s*,\s*/)
      @profiles = profiles_for_tag(params[:topic])
    elsif params[:category_id]
      profiles_for_category(params[:category_id], params[:tag_search])
    elsif params[:search]
      @profiles = profiles_for_search

      # sum of search results concerning certain attributes
      @aggs = profiles_for_search.response.aggregations
      @aggs_languages = @aggs[:lang][:buckets]
      @aggs_cities = @aggs[:city][:buckets]
      @aggs_countries = @aggs[:country][:buckets]
    elsif params[:tag_search]
      @tags = params[:tag_search].split(/\s*,\s*/)
      @profiles = Profile.is_published.has_tags(@tags).page(params[:page]).per(24)
      @profiles_tagged_count = @profiles.total_count
    else
      @profiles = profiles_for_index
      @profiles_count = Profile.is_published.size
    end
    @tags_most_used_200 = if params[:all_lang]
                            ActsAsTaggableOn::Tag.with_published_profile.most_used(200)
                          else
                            ActsAsTaggableOn::Tag.with_published_profile.with_language(I18n.locale).most_used(200)
                          end
  end

  def show
    if @profile.published? || can_edit_profile?(current_profile, @profile)
      @message = Message.new
      @medialinks = @profile.medialinks.order(:position)
    else
      redirect_to profiles_url, notice: I18n.t('flash.profiles.show_no_permission')
    end
  end

  # should reuse the devise view
  def edit
    build_missing_translations(@profile)
  end

  def update
    if @profile.update_attributes(profile_params)
      redirect_to @profile, notice: I18n.t('flash.profiles.updated', profile_name: @profile.name_or_email)
    elsif current_profile
      build_missing_translations(@profile)
      render action: 'edit'
    end
  end

  def destroy
    @profile.destroy
    redirect_to profiles_url, notice: I18n.t('flash.profiles.destroyed', profile_name: @profile.name_or_email)
  end

  def require_permission
    return if can_edit_profile?(current_profile, @profile)

    redirect_to profiles_url, notice: I18n.t('flash.profiles.no_permission')
  end

  def render_footer?
    false
  end

  def typeahead
    suggester_fields  = []
    suggester_options = []
    suggestions = Profile.typeahead(params[:q])
                         .select { |key, _value| key.to_s.match(/.*_suggest/) }
    suggestions.each do |s|
      suggester_fields.push(s)
    end
    suggester_fields.map { |s| suggester_options.push(s[1].first['options']) }
    suggestions_ordered = suggestions_upcase(suggester_options)
    respond_with(suggestions_ordered)
  end

  private

  def suggestions_upcase(suggestions_raw)
    sugg_upcase_complete = []
    sugg_text = []
    suggestions_raw.flatten.sort_by { |s| s['score'] }

    sugg_upcase_complete = suggestions_raw.flatten.each do |s|
      s['text'] = s['text'].split.map(&:capitalize).join(' ')
      sugg_text.push(s['text'])
    end

    duplicates = sugg_text.select { |element| sugg_text.count(element) > 1 }
    delete_duplicates(sugg_upcase_complete, duplicates)
  end

  def delete_duplicates(upcased_suggestions, dupli)
    if dupli != []
      dupli.uniq!.each do |x|
        upcased_suggestions.find do |s|
          if x == s['text']
            upcased_suggestions.delete(s)
            dupli.delete(x)
          end
        end
      end
    end
    upcased_suggestions
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @profile = Profile.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def profile_params
    params.require(:profile).permit(
      :email,
      :password,
      :password_confirmation,
      :remember_me,
      :country,
      { iso_languages: [] },
      :firstname,
      :lastname,
      :picture,
      :remove_picture,
      :content,
      :name,
      :topic_list,
      :medialinks,
      :slug,
      :admin_comment,
      :main_topic_en,
      :main_topic_de,
      :bio_en,
      :bio_de,
      :twitter_de,
      :twitter_en,
      :website_de,
      :website_en,
      :website_2_de,
      :website_2_en,
      :website_3_de,
      :website_3_en,
      :city_de,
      :city_en,
      :image,
      feature_ids: [],
      translations_attributes: %i[id bio main_topic twitter website city locale]
    )
  end

  def custom_params
    permitted = Profile.globalize_attribute_names
    params[:profile].permit(*permitted)
  end

  def profiles_for_index
    Profile.is_published
           .includes(:translations)
           .main_topic_translated_in(I18n.locale)
           .random
           .page(params[:page])
           .per(24)
  end

  def profiles_for_tag(tag_names)
    # uniq turn the relation into a array and to paginate the array we
    # need the Kaminari.paginate_array method
    profiles_array = Profile.is_published
                             .includes(:taggings, :translations)
                             .joins(:topics)
                             .where(
                               tags: {
                                 name: tag_names
                               }
                             )
                             .random
                             .uniq

    Kaminari.paginate_array(profiles_array).page(params[:page]).per(24)
  end

  def profiles_for_category(category_id, tags_search=nil)
    @categories = Category.sorted_categories
    @category = Category.find(category_id)
    @tags_in_category_published = ActsAsTaggableOn::Tag
                                  .with_published_profile
                                  .belongs_to_category(params[:category_id])
                                  .translated_in_current_language_and_not_translated(I18n.locale)
    tag_names = @tags_in_category_published.pluck(:name)


    @category = params[:category_id] ? Category.find(params[:category_id]) : Category.find(1)
    Category.all.includes(:translations).each do |category|
      instance_variable_set("@tags_#{category.short_name}",
        ActsAsTaggableOn::Tag.belongs_to_category(category.id)
                              .belongs_to_more_than_one_profile
                              .with_published_profile
                              .translated_in_current_language_and_not_translated(I18n.locale))
    end
    @tags_in_category_published = ActsAsTaggableOn::Tag
                                  .with_published_profile
                                  .belongs_to_category(params[:category_id])
                                  .translated_in_current_language_and_not_translated(I18n.locale)
    tag_names = @tags_in_category_published.pluck(:name)
    @profiles = profiles_for_tag(tag_names)


    if tags_search.present?
      @tags = tags_search.split(/\s*,\s*/) if tags_search
      @profiles = profiles_for_tag(@tags)
    else
      @profiles = profiles_for_tag(tag_names)
    end
  end

  def profiles_for_search
    Profile.is_published
           .includes(:taggings, :translations)
           .search(params[:search], params[:filter_countries], params[:filter_cities], params[:filter_lang])
           .page(params[:page]).per(24)
           .records
  end

end
