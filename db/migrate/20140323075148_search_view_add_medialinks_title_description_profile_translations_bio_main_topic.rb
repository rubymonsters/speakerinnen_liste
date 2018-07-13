  class SearchViewAddMedialinksTitleDescriptionProfileTranslationsBioMainTopic < ActiveRecord::Migration[4.2]
  def up
    execute <<-SQL
      DROP VIEW searches;
      CREATE VIEW searches AS
      SELECT profiles.id AS profile_id, 
        array_to_string( 
          ARRAY[profiles.firstname, profiles.lastname, profiles.languages, profiles.city, 
            string_agg(DISTINCT medialinks.title, ' '), 
            string_agg(DISTINCT medialinks.description, ' '), 
            string_agg(DISTINCT profile_translations.bio, ' '), 
            string_agg(DISTINCT profile_translations.main_topic, ' '),
            string_agg(DISTINCT tags.name, ' ')], ' ') AS search_field
      FROM profiles
      LEFT JOIN medialinks ON medialinks.profile_id = profiles.id
      LEFT JOIN profile_translations ON profile_translations.profile_id = profiles.id
      LEFT JOIN taggings ON taggings.taggable_id = profiles.id 
      LEFT JOIN tags ON tags.id = taggings.tag_id
      GROUP BY profiles.id
    SQL

  end

  def down
  end
end
