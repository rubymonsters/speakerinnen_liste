# frozen_string_literal: true

class Search
  attr_reader :profiles

  def initialize(query)
    @profiles = Profile
      .includes(:translations, taggings: :tag)
      .is_published
      .references(:tag)
      .where(fields_to_search, query: "%#{query}%")
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

  def aggregations_hash
    @aggs ||= {
      languages: group_by_languages,
      countries: group_by_countries,
      cities: group_by_cities,
      states: group_by_states
    }
  end

  private

  def group_by_languages
    languages_in_profiles = profiles
      .map(&:iso_languages)
      .flatten
      .uniq

    languages_in_profiles.each_with_object({}) do |language, memo|
      memo[language] = profiles
        .select{ |profile| profile.iso_languages.include?(language) }.size
    end
  end

  def group_by_countries
    profiles.group_by(&:country).each_with_object({}) do |(country, profiles), memo|
      next unless country

      memo[country] = profiles.size
    end
  end

  def group_by_states
    states_in_profiles = profiles
      .map(&:state)
      .flatten
      .uniq
      .reject(&:blank?)

    states_in_profiles.each_with_object({}) do |state, memo|
      memo[state] = profiles
        .select { |profile| profile.state.include?(state) if profile.state.present? }.size
    end
  end

  def group_by_cities
    cities_in_profiles = profiles
      .map(&:city)
      .flatten
      .uniq
      .reject(&:blank?)

    cities_in_profiles.each_with_object({}) do |city, memo|
      memo[city] = profiles
        .select do |profile|
          if profile.city.present?
            profile.city.include?(city)
          end
        end.size
    end
  end

end
