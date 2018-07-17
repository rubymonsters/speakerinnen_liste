class SearchViewVersion2 < ActiveRecord::Migration[4.2]
  def up
    execute <<-SQL
      DROP VIEW searches;
      CREATE VIEW searches AS
      SELECT profiles.id AS profile_id,
        array_to_string(
          ARRAY[profiles.bio, profiles.firstname, profiles.lastname, profiles.languages, profiles.city,
            array_to_string(array_agg(DISTINCT tags.name), ' ')], ' ') AS search_field
      FROM profiles
      LEFT JOIN taggings ON taggings.taggable_id = profiles.id
      LEFT JOIN tags ON tags.id = taggings.tag_id
      GROUP BY profiles.id;

    SQL

  end

  def down
  end

end
