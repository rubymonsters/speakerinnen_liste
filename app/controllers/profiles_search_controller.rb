class ProfilesSearchController < ApplicationController
  def show
    @profiles = ProfilesSearch.new(params[:search]).results.page(params[:page]).per(16)

    if params[:search][:languages] && params[:search][:languages].size != 0
      @selected_languages = []
      params[:search][:languages].each do |l|
        @selected_languages << LanguageList::LanguageInfo.find_by_iso_639_1(l).name
      end
      @selected_languages = @selected_languages.join(" ")
    end

    if params[:search].include? :quick
      search_params = params[:search][:quick]
    else
    binding.pry
      search_params = params[:search][:name] + " " + params[:search][:city] + " " + params[:search][:twitter] + " " + params[:search][:topics] + " " +  @selected_languages.to_s
    end

    if @profiles.any?
      flash[:notice] = (I18n.t(:success, scope: 'search', searchparams: search_params).html_safe) + (I18n.t(:result, scope: 'search', count: @profiles.size).html_safe)
    else
      flash[:notice] = (I18n.t(:empty, scope: 'search', searchparams: search_params).html_safe)
    end
  end

end
