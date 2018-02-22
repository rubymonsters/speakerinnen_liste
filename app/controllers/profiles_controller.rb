class ProfilesController < ApplicationController
  include ProfilesHelper
  include CategoriesHelper
  include ActsAsTaggableOn::TagsHelper

  before_action :set_profile, only: %i[show edit update destroy require_permission]

  before_filter :require_permission, only: %i[edit destroy update]

  respond_to :json

  def index
    if params[:topic]
      @profiles = profiles_for_tag(params[:topic])
    elsif params[:category_id]
      profiles_for_category
    elsif params[:search]
      @profiles = profiles_for_search

      # sum of search results concerning certain attributes
      @aggs = profiles_for_search.response.aggregations
      @aggs_languages = @aggs[:lang][:buckets]
      @aggs_cities = @aggs[:city][:buckets]
      @aggs_countries = @aggs[:country][:buckets]
    else
      @profiles = profiles_for_index
      @profiles_count = Profile.is_published.count
    end
    if params[:all_lang]
      @tags_most_used_200 = ActsAsTaggableOn::Tag.with_published_profile.most_used(200)
    else
      @tags_most_used_200 = ActsAsTaggableOn::Tag.with_published_profile.with_language(I18n.locale).most_used(200)
    end
    @tags_all = ActsAsTaggableOn::Tag.all
  end

  def show
    if @profile.published? || can_edit_profile?(current_profile, @profile)
      @message = Message.new
      @medialinks = @profile.medialinks.order(:position)
    else
      redirect_to profiles_url, notice: I18n.t('flash.profiles.show_no_permission')
    end
    @topics = []
    @topics << @profile.topics.with_language(I18n.locale)
    @topics << @profile.topics.without_language
    @topics = @topics.flatten.uniq
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
      :talks,
      :content,
      :name,
      :topic_list,
      :media_url,
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
      :city_de,
      :city_en,
      translations_attributes: %i[id bio main_topic twitter website city locale]
    )
  end

  def custom_params
    permitted = Profile.globalize_attribute_names
    params[:profile].permit(*permitted)
  end

  def profiles_for_index
    Profile.is_published
           .main_topic_translated_in(I18n.locale)
           .random
           .page(params[:page])
           .per(24)
  end

  def profiles_for_tag(tag_names)
    Profile.is_published
           .random
           .tagged_with(tag_names, any: true)
           .page(params[:page])
           .per(24)
  end

  def profiles_for_category
    @category = Category.find(params[:category_id])
    @tags_in_category_published = ActsAsTaggableOn::Tag.belongs_to_category(params[:category_id]).with_published_profile.with_language(I18n.locale)
    tag_names = @tags_in_category_published.pluck(:name)
    @tags_most_used_200 = @tags_in_category_published.most_used(200)
    @profiles = profiles_for_tag(tag_names)
  end

  def profiles_for_search
    Profile.is_published
           .search(params[:search], params[:filter_countries], params[:filter_cities], params[:filter_lang])
           .page(params[:page]).per(24)
           .records
  end
end
