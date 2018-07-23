class AddSearchSqlView < ActiveRecord::Migration[4.2]
  def up
    execute <<-SQL
      CREATE VIEW searches AS
      SELECT profiles.id AS profile_id, profiles.bio, profiles.firstname, profiles.lastname, profiles.languages, profiles.city, tags.name AS tag FROM profiles
      LEFT JOIN taggings ON taggings.taggable_id = profiles.id 
      LEFT JOIN tags ON tags.id = taggings.tag_id;
    SQL

  end

  def down
    execute <<-SQL
      DROP VIEW searches
    SQL
  end
end
