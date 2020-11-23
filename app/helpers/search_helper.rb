# frozen_string_literal: true

module SearchHelper
  def result_from_filter?
    params[:filter_countries].present? || params[:filter_cities].present? || params[:filter_lang].present?
  end

  def filters_hash(aggs_countries, aggs_cities, aggs_languages)
    filter_params = { search: params[:search], filter_countries: params[:filter_countries], filter_cities: params[:filter_cities], filter_lang: params[:filter_lang] }

    [
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
  end
end
