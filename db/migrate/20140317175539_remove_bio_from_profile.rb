class RemoveBioFromProfile < ActiveRecord::Migration[4.2]
  def up
    execute <<-SQL
      DROP VIEW searches;
      CREATE VIEW searches AS
      SELECT profiles.id AS profile_id, 
        array_to_string( 
          ARRAY[profiles.firstname, profiles.lastname, profiles.languages, profiles.city, 
            array_to_string(array_agg(DISTINCT tags.name), ' ')], ' ') AS search_field
      FROM profiles
      LEFT JOIN taggings ON taggings.taggable_id = profiles.id 
      LEFT JOIN tags ON tags.id = taggings.tag_id
      GROUP BY profiles.id;
    SQL
    remove_column :profiles, :bio
    remove_column :profiles, :main_topic
  end

  def down
    add_column :profiles, :bio, :text
    add_column :profiles, :main_topic, :string
  end
end
