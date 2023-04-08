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
end
