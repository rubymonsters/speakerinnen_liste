class SearchViewAddMedialinksTitleDescriptionProfileTranslationsBioMainTopic < ActiveRecord::Migration
  def up
    execute <<-SQL
      DROP VIEW searches;
      CREATE VIEW searches AS
      SELECT profiles.id AS profile_id, 
        array_to_string( 
          ARRAY[profiles.firstname, profiles.lastname, profiles.languages, profiles.city, 
            medialinks.title, medialinks.description, profile_translations.bio, profile_translations.main_topic, 
            array_to_string(array_agg(DISTINCT tags.name), ' ')], ' ') AS search_field
      FROM profiles
      LEFT JOIN medialinks ON medialinks.profile_id = profiles.id
      LEFT JOIN profile_translations ON profile_translations.profile_id = profiles.id
      LEFT JOIN taggings ON taggings.taggable_id = profiles.id 
      LEFT JOIN tags ON tags.id = taggings.tag_id
      GROUP BY profiles.id, medialinks.title, medialinks.description, profile_translations.main_topic, profile_translations.bio;

    SQL

  end

  def down
  end
end
