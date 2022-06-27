# frozen_string_literal: true

module SearchHelper
  def result_from_filter?
    params[:filter_countries].present? || params[:filter_cities].present? || params[:filter_lang].present? || params[:filter_states].present?
  end

  def all_states
    t(:states).map(&:last).inject(&:merge)
  end

  def filter_params
    filter_params = {
      search: params[:search],
      filter_countries: params[:filter_countries],
      filter_cities: params[:filter_cities],
      filter_lang: params[:filter_lang],
      filter_states: params[:filter_states]
    }
  end

  def filters_hash(aggs_countries, aggs_states, aggs_cities, aggs_languages)
    filter_params = {
      search: params[:search],
      filter_countries: params[:filter_countries],
      filter_cities: params[:filter_cities],
      filter_lang: params[:filter_lang],
      filter_states: params[:filter_states]
    }

    hashes = [
      {
        key: 'countries',
        title: :countries_agg,
        param_val: params[:filter_countries],
        all_text: :all_countries,
        filter_params_all: filter_params.merge(filter_countries: nil),
        filter_params_func: ->(term_key) { filter_params.merge(filter_countries: term_key.downcase) },
        aggregations: aggs_countries,
        link_text_func: ->(term_key) { ISO3166::Country.find_country_by_alpha2(term_key).translation(I18n.locale) }
      },
      {
        key: 'states',
        title: :states_agg,
        param_val: params[:filter_states],
        all_text: :all_states,
        filter_params_all: filter_params.merge(filter_states: nil),
        filter_params_func: ->(term_key) { filter_params.merge(filter_states: term_key) },
        aggregations: aggs_states,
        link_text_func: ->(term_key) { all_states[term_key&.to_sym] }
      },
      {
        key: 'cities',
        title: :cities_agg,
        param_val: params[:filter_cities],
        all_text: :all_cities,
        filter_params_all: filter_params.merge(filter_cities: nil),
        filter_params_func: ->(term_key) { filter_params.merge(filter_cities: term_key) },
        aggregations: aggs_cities,
        link_text_func: ->(term_key) { term_key }
      },
      {
        key: 'languages',
        title: :languages_agg,
        param_val: params[:filter_lang],
        all_text: :all_languages,
        filter_params_all: filter_params.merge(filter_lang: nil),
        filter_params_func: ->(term_key) { filter_params.merge(filter_lang: term_key) },
        aggregations: aggs_languages,
        link_text_func: ->(term_key) { t(term_key, scope: 'iso_639_1').capitalize }
      }
    ]

    hashes.reject do |hash|
      (hash[:key] == 'countries' || hash[:key] == 'states') && current_region
    end
  end
end
