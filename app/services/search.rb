# frozen_string_literal: true

class Search
  attr_reader :profiles

  def initialize(query, filter_params = {})
    chain = Profile
      .includes(:translations, taggings: :tag)
      .is_published
      .references(:translations, taggings: :tag)
      .where(fields_to_search, query: "%#{query}%")

    if filter_params[:filter_language]
      chain = chain
        .where('iso_languages LIKE ?', "%#{filter_params[:filter_language]}%")
    end

    if filter_params[:filter_city]
      chain = chain
        .where('city ILIKE ?', "%#{filter_params[:filter_city]}%")
    end

    if filter_params[:filter_state]
      chain = chain
        .where(state: filter_params[:filter_state])
    end

    if filter_params[:filter_country]
      chain = chain
        .where(country: filter_params[:filter_country])
    end

    @profiles ||= chain
  end

  def fields_to_search
    <<~sql
      (
        (firstname || ' ' || lastname ILIKE :query) OR
        (twitter ILIKE :query) OR
        (bio ILIKE :query) OR
        (main_topic ILIKE :query) OR
        (city ILIKE :query) OR
        (state ILIKE :query) OR
        (tags.name ILIKE :query)
      )
    sql
  end

  # https://pganalyze.com/blog/full-text-search-ruby-rails-postgres
#   SELECT country, state, count(*)
# FROM profiles
# GROUP BY grouping sets( (country), (state), () )
# ORDER BY COUNT(country) DESC, COUNT(state) DESC;
  def aggregations_hash_group
    initial_agg_hash = {
      states: profiles.group(:state).size,
      languages: {},
      cities: {},
      countries: profiles.group(:country).size
    }

    raw_aggs = profiles.each_with_object(initial_agg_hash) do |profile, memo|
      memo[:states][profile.state] = memo[:states][profile.state].present? ? memo[:states][profile.state] + 1 : 1
      profile.iso_languages.each do |language|
       memo[:languages][language] = memo[:languages][language].present? ? memo[:languages][language] + 1 : 1
      end
      profile.cities.each do |city|
        memo[:cities][city] = memo[:cities][city].present? ? memo[:cities][city] + 1 : 1
      end
    end

    raw_aggs.each_with_object({}) do |(key, value), memo|
      memo[key] = value.except(nil, '').sort_by{|k,v| -v}.to_h
    end
  end

  def aggregations_hash
    initial_agg_hash = {
      states: {},
      languages: {},
      cities: {},
      countries: {}
    }

    raw_aggs = profiles.each_with_object(initial_agg_hash) do |profile, memo|
      memo[:states][profile.state] = memo[:states][profile.state].present? ? memo[:states][profile.state] + 1 : 1
      profile.iso_languages.each do |language|
       memo[:languages][language] = memo[:languages][language].present? ? memo[:languages][language] + 1 : 1
      end
      memo[:countries][profile.country] = memo[:countries][profile.country].present? ? memo[:countries][profile.country] + 1 : 1
      profile.cities.each do |city|
        memo[:cities][city] = memo[:cities][city].present? ? memo[:cities][city] + 1 : 1
      end
    end

    raw_aggs.each_with_object({}) do |(key, value), memo|
      memo[key] = value.except(nil, '').sort_by{|k,v| -v}.to_h
    end
  end
end
