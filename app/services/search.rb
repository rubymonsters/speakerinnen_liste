# frozen_string_literal: true

class Search
  attr_reader :profiles

  def initialize(query, filter_params = {})
    chain = Profile
      .includes(:translations, taggings: :tag)
      .is_published
      .references(:tag)
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
end
