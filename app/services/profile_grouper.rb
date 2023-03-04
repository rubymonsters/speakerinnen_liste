class ProfileGrouper
  CITY_QUERY =
    <<~HEREDOC
      WITH normalized_cities_table AS
        (
          SELECT
            profile_id,
            TRIM(
              UNNEST(
                NULLIF(
                  REGEXP_SPLIT_TO_ARRAY(
                    city,
                    ',|/|\\|| und | and | I | & | - '
                  ),
                  '{""}'
                )
              )
            ) AS normalized_city
            FROM profile_translations
            WHERE locale = $1
        )
      SELECT normalized_city, COUNT(profile_id)
        FROM normalized_cities_table
        GROUP BY normalized_city
        HAVING COUNT(profile_id) > 1
    HEREDOC

  LANGUAGE_QUERY =
    <<~HEREDOC
      SELECT
        ARRAY_TO_STRING(
          REGEXP_MATCHES(iso_languages, '\- ([a-z]{2})', 'g'),
          ''
        ) AS iso_language,
        COUNT(id)
        FROM profiles
        GROUP BY iso_language
    HEREDOC

  REST_QUERY =
    <<~HEREDOC
      SELECT
        country,
        state,
        COUNT(id)
      FROM profiles
      GROUP BY GROUPING SETS (country, state)
    HEREDOC

  attr_reader :locale
  private :locale

  def initialize(locale)
    @locale = locale
  end

  def grouped_cities
    binds = [ ActiveRecord::Relation::QueryAttribute.new("locale", locale, ActiveRecord::Type::String.new)]
    @grouped_cities ||= ActiveRecord::Base.connection.exec_query(CITY_QUERY, 'sql', binds).rows
  end

  def grouped_languages
    @grouped_languages ||= ActiveRecord::Base.connection.exec_query(LANGUAGE_QUERY).rows
  end

  def grouped_rest
    @grouped_rest ||= ActiveRecord::Base.connection.exec_query(REST_QUERY)
  end

  def agg_hash
    {
      languages: grouped_languages.to_h,
      cities: grouped_cities.to_h,
      countries: grouped_rest.map { |row| {row["country"] => row["count"]} if row["country"].present? }.compact.inject(:merge!),
      states: grouped_rest.map { |row| {row["state"] => row["count"]} if row["state"].present? }.compact.inject(:merge!)
    }
  end
end
