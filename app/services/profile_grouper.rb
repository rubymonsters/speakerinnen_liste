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
            WHERE profile_id = ANY($1::int[]) AND locale = $2
        )
      SELECT normalized_city, COUNT(profile_id)
        FROM normalized_cities_table
        GROUP BY normalized_city
        ORDER BY COUNT(profile_id) DESC
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
        WHERE id = ANY($1::int[])
        GROUP BY iso_language
        ORDER BY COUNT(id) DESC
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
