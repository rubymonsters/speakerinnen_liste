class ProfileGrouper
  # The one definition of "how a free-text city field is broken into cities".
  # Profile.by_city MUST normalise with this same regexp, otherwise the number
  # shown next to a facet stops matching the number of results you get when you
  # click it.
  CITY_SPLIT_REGEXP = ',|/|\\|| und | and | I | & | - '.freeze

  # Buckets are grouped case-insensitively ("berlin" and "Berlin" are one city)
  # and counted with DISTINCT (a city of "Berlin, Berlin" is one profile, not
  # two). The label shown in the UI is the most common spelling in the data, so
  # the German page still reads "Berlin" rather than "berlin".
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
                    '#{CITY_SPLIT_REGEXP}'
                  ),
                  '{""}'
                )
              )
            ) AS normalized_city
            FROM profile_translations
            WHERE profile_id = ANY($1::int[]) AND locale = $2
        )
      SELECT
          MODE() WITHIN GROUP (ORDER BY normalized_city) AS normalized_city,
          COUNT(DISTINCT profile_id) AS count
        FROM normalized_cities_table
        WHERE normalized_city <> ''
        GROUP BY LOWER(normalized_city)
        ORDER BY COUNT(DISTINCT profile_id) DESC
    HEREDOC

  LANGUAGE_QUERY =
    <<~HEREDOC
      SELECT
        ARRAY_TO_STRING(
          -- Capture the WHOLE code up to the end of the YAML line. Matching a
          -- fixed [a-z]{2} truncated 3-letter codes ("sgn" -> "sg", "wen" ->
          -- "we"), producing buckets that matched no profile when clicked.
          REGEXP_MATCHES(iso_languages, '- ([a-z]+)(?=\n)', 'g'),
          ''
        ) AS iso_language,
        COUNT(DISTINCT id)
        FROM profiles
        WHERE id = ANY($1::int[])
        GROUP BY iso_language
        ORDER BY COUNT(DISTINCT id) DESC
    HEREDOC

  REST_QUERY =
    <<~HEREDOC
      SELECT
        country,
        state,
        COUNT(id)
      FROM profiles
      WHERE id = ANY($1::int[])
      GROUP BY GROUPING SETS (country, state)
      ORDER BY COUNT(id) DESC
    HEREDOC

  attr_reader :ids, :locale
  private :ids, :locale

  def initialize(locale, ids)
    @locale = locale
    @ids = ids
  end

  def agg_hash
    {
      languages: grouped_languages.to_h,
      cities: grouped_cities.to_h,
      countries: grouped_rest.map { |row| {row["country"] => row["count"]} if row["country"].present? }.compact.inject(:merge!),
      states: grouped_rest.map { |row| {row["state"] => row["count"]} if row["state"].present? }.compact.inject(:merge!)
    }
  end

  private

  def grouped_cities
    binds = [
      ActiveRecord::Relation::QueryAttribute.new("profile_id", ids_for_sql, ActiveRecord::Type::String.new),
      ActiveRecord::Relation::QueryAttribute.new("locale", locale, ActiveRecord::Type::String.new)
    ]
    @grouped_cities ||= ActiveRecord::Base.connection.exec_query(CITY_QUERY, 'sql', binds).rows
  end

  def grouped_languages
    binds = [
      ActiveRecord::Relation::QueryAttribute.new("id", ids_for_sql, ActiveRecord::Type::String.new)
    ]
    @grouped_languages ||= ActiveRecord::Base.connection.exec_query(LANGUAGE_QUERY, 'sql', binds).rows
  end

  def grouped_rest
    binds = [
      ActiveRecord::Relation::QueryAttribute.new("id", ids_for_sql, ActiveRecord::Type::String.new)
    ]
    @grouped_rest ||= ActiveRecord::Base.connection.exec_query(REST_QUERY, 'sql', binds)
  end

  def ids_for_sql
    ids.to_s.sub("[", "{").sub("]", "}")
  end
end
