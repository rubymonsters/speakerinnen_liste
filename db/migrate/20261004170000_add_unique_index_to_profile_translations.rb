# Mobility's table backend assumes one row per (profile_id, locale); it reads
# with an unordered `find` and silently ignores any surplus row. Nothing in the
# schema enforced that, so duplicates accumulated and leaked into the SQL-built
# facets and search vector while staying invisible in the app.
class AddUniqueIndexToProfileTranslations < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def up
    duplicates = select_value(<<~SQL)
      SELECT COUNT(*) FROM (
        SELECT 1 FROM profile_translations
        GROUP BY profile_id, locale HAVING COUNT(*) > 1
      ) d
    SQL

    if duplicates.to_i.positive?
      raise <<~MSG
        #{duplicates} (profile_id, locale) groups still have duplicate rows, so the
        unique index cannot be created. Collapse them first:

          bundle exec rake profiles:translation_duplicates:report
          bundle exec rake profiles:translation_duplicates:repair APPLY=1

        then re-run this migration.
      MSG
    end

    add_index :profile_translations, %i[profile_id locale],
              unique: true,
              name: 'index_profile_translations_on_profile_id_and_locale',
              algorithm: :concurrently
  end

  def down
    remove_index :profile_translations, name: 'index_profile_translations_on_profile_id_and_locale'
  end
end
