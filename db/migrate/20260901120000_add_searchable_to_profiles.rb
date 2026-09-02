class AddSearchableToProfiles < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  # Inlined rather than referencing Profile::SEARCH_VECTOR_SQL so the migration
  # keeps working if the model's definition moves on.
  BACKFILL = <<~SQL.squish
    UPDATE profiles SET searchable =
      setweight(to_tsvector('simple', coalesce(profiles.firstname, '')), 'A') ||
      setweight(to_tsvector('simple', coalesce(profiles.lastname, '')), 'A') ||
      setweight(to_tsvector('simple', coalesce(profiles.state, '')), 'C') ||
      setweight(to_tsvector('simple', coalesce(profiles.country, '')), 'C') ||
      setweight(to_tsvector('simple', coalesce((SELECT string_agg(pt.bio, ' ')
        FROM profile_translations pt WHERE pt.profile_id = profiles.id), '')), 'C') ||
      setweight(to_tsvector('simple', coalesce((SELECT string_agg(pt.city, ' ')
        FROM profile_translations pt WHERE pt.profile_id = profiles.id), '')), 'B') ||
      setweight(to_tsvector('simple', coalesce((SELECT string_agg(pt.main_topic, ' ')
        FROM profile_translations pt WHERE pt.profile_id = profiles.id), '')), 'A') ||
      setweight(to_tsvector('simple', coalesce((SELECT string_agg(t.name, ' ')
        FROM taggings tg JOIN tags t ON t.id = tg.tag_id
        WHERE tg.taggable_id = profiles.id AND tg.taggable_type = 'Profile'
          AND tg.context = 'topics'), '')), 'A')
  SQL

  def up
    add_column :profiles, :searchable, :tsvector
    execute BACKFILL
    add_index :profiles, :searchable, using: :gin, algorithm: :concurrently
  end

  def down
    remove_index :profiles, :searchable
    remove_column :profiles, :searchable
  end
end
